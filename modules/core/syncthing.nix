{ host, ... }: 
let
  inherit (import ../../hosts/${host}/variables.nix) username;
in
{
  services.syncthing = {
    enable = false;
    user = "${username}";
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
  };
}
