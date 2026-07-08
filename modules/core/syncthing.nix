{ host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) username;
in
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "${username}";
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
  };
}
