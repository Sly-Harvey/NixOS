{
  pkgs,
  lib,
  ...
}: let
  # Recursively find all .nix files in the current directory and subdirectories
  # Ignores default.nix only at the top level
  findNixFiles = {
    path,
    isTopLevel ? false,
  }: let
    entries = builtins.readDir path;

    # Filter .nix files based on level (exclude default.nix at top level only)
    nixFileFilter = name: type:
      type
      == "regular"
      && lib.hasSuffix ".nix" name
      && (!isTopLevel || name != "default.nix");

    # Get all matching .nix files in current directory
    files = lib.filterAttrs nixFileFilter entries;
    filePaths = map (name: path + "/${name}") (lib.attrNames files);

    # Find subdirectories to recurse into
    dirs = lib.filterAttrs (_: type: type == "directory") entries;
    subDirPaths = map (name: path + "/${name}") (lib.attrNames dirs);

    # Recurse into subdirectories (not at top level)
    subFiles = lib.concatMap (dir: findNixFiles {path = dir;}) subDirPaths;
  in
    filePaths ++ subFiles;

  # Find all relevant .nix files
  nixFiles = findNixFiles {
    path = ./.;
    isTopLevel = true;
  };

  # Import and validate each script file
  scriptDerivations = let
    importScript = file: let
      fileName = builtins.baseNameOf file;
      imported = import file;

      # Check if the imported file is a function expecting pkgs
      isFunction = builtins.isFunction imported;

      # Try to create a derivation from the file
      drv =
        if isFunction
        then imported pkgs
        else imported;
    in {
      inherit file fileName drv;
      isValid = lib.isDerivation drv;
      error = "Script '${fileName}' did not evaluate to a derivation";
    };

    # Import all scripts
    importedScripts = map importScript nixFiles;

    invalidScripts = builtins.filter (s: !s.isValid) importedScripts;

    _ =
      builtins.map (
        s:
          builtins.trace "Warning: ${s.error} (${toString s.file})" null
      )
      invalidScripts;

    validDerivations =
      builtins.map (s: s.drv)
      (builtins.filter (s: s.isValid) importedScripts);
  in
    validDerivations;

  scriptCount = builtins.length scriptDerivations;
  _ = builtins.trace "Found ${toString scriptCount} script derivations" null;
in {
  environment.systemPackages = scriptDerivations;
}
