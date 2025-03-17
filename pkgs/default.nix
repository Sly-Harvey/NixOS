{
  pkgs,
  lib,
  sddmTheme,
  ...
}: let
  excludeFiles = [
    "${toString ./lact.nix}"
    # Add more files here as needed
  ];

  # Define special arguments for specific files
  specialArgs = {
    "${toString ./pkgs/sddm-themes/astronaut.nix}" = { theme = sddmTheme; };
  };

  findNixFiles = isTopLevel: path: exclude: let
    entries = builtins.readDir path;
    files = lib.filterAttrs (name: type:
      type == "regular" &&
      lib.hasSuffix ".nix" name &&
      !(isTopLevel && name == "default.nix") &&
      !lib.elem (toString (path + "/${name}")) exclude
    ) entries;
    filePaths = map (name: path + "/${name}") (lib.attrNames files);
    # Find subdirectories to recurse into
    dirs = lib.filterAttrs (name: type: type == "directory") entries;
    subDirPaths = map (name: path + "/${name}") (lib.attrNames dirs);
    subFiles = lib.concatMap (dir: findNixFiles false dir exclude) subDirPaths;
  in
    filePaths ++ subFiles;

  nixFiles = findNixFiles true ./. excludeFiles;

  derivations = builtins.filter lib.isDerivation (map (file: 
    let
      fileStr = toString file;
      args = if lib.hasAttr fileStr specialArgs then specialArgs.${fileStr} else {};
    in
      pkgs.callPackage file args
  ) nixFiles);
in {
  environment.systemPackages = derivations;
}
