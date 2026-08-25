{ ... }:
{
  imports = [
    ./boot.nix
    ./bash.nix
    ./zsh.nix
    ./starship.nix
    ./fonts.nix
    ./hardware.nix
    ./network.nix
    ./dns.nix
    ./nh.nix
    ./packages.nix
    ./printing.nix
    ./sddm.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./users.nix
    # ./syncthing.nix
    # ./jellyfin.nix
    # ./dlna.nix
    # ./games.nix
    # ./flatpak.nix
    # ./virtualisation.nix
  ];
}
