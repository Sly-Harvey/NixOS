{ ... }:
{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./hardware.nix
    ./network.nix
    ./nh.nix
    ./packages.nix
    ./printing.nix
    ./sddm.nix
    ./security.nix
    ./dns.nix
    ./services.nix
    # ./games.nix
    # ./dlna.nix
    ./syncthing.nix
    ./system.nix
    ./users.nix
    # ./flatpak.nix
    # ./virtualisation.nix
  ];
}
