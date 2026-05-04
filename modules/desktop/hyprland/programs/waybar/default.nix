{ host, lib, ... }:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) waybarTheme;
in
{
  imports = [
    ./${waybarTheme}.nix
  ];
}
