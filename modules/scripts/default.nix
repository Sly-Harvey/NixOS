{
  pkgs,
  lib,
  ...
}: let
  # Get all .nix files except default.nix
  scriptFiles = lib.filterAttrs (
    name: type:
      type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) (builtins.readDir ./.);

  # Build a list of derivations
  scriptDerivations =
    lib.mapAttrsToList (
      name: _: let
        scriptName = lib.removeSuffix ".nix" name;
        drv = pkgs.callPackage (./. + "/${name}") {};
      in
        if lib.isDerivation drv
        then drv
        else throw "Script ${scriptName} from ${name} is not a derivation, got: ${builtins.toString drv}"
    )
    scriptFiles;
in {
  environment.systemPackages = scriptDerivations;
}
