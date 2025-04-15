{
  pkgs,
  lib,
  ...
}: let
  # Recursively find all .nix files, excluding default.nix only at the top level
  findNixFiles = isTopLevel: path: let
    entries = builtins.readDir path;
    files =
      if isTopLevel
      then lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix") entries
      else lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) entries;
    filePaths = map (name: path + "/${name}") (lib.attrNames files);
    # Find subdirectories to recurse into
    dirs = lib.filterAttrs (_name: type: type == "directory") entries;
    subDirPaths = map (name: path + "/${name}") (lib.attrNames dirs);
    subFiles = lib.concatMap (findNixFiles false) subDirPaths;
  in
    filePaths ++ subFiles;

  nixFiles = findNixFiles true ./.;

  # Convert each .nix file into a derivation, with validation
  # scriptDerivations = builtins.filter lib.isDerivation (map (file: pkgs.callPackage file {}) nixFiles);
  scriptDerivations =
    map (
      file: let
        drv = pkgs.callPackage file {};
      in
        if lib.isDerivation drv
        then drv
        else throw "Script from ${toString file} is not a derivation, got: ${builtins.toString drv}"
    )
    nixFiles;
in {
  environment.systemPackages = scriptDerivations;
}
