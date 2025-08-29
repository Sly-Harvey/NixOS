{
  pkgs,
  settings,
  ...
}:
let
  lib = pkgs.lib;
in {
  pokego = pkgs.callPackage ./pokego.nix {};
  sddm-astronaut = pkgs.callPackage ./sddm-themes/astronaut.nix { theme = settings.sddmTheme; };

  stability-matrix         = import ./stability-matrix { inherit pkgs lib; };
  stability-matrix-updater = import ./stability-matrix/update.nix { inherit pkgs; };
  stability-matrix-pin     = import ./stability-matrix/set-version.nix { inherit pkgs; };
}
