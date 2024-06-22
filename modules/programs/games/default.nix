{pkgs, ...}: {
  imports = [
    ./gamemode.nix
    ./steam.nix
    ./lutris.nix
    ./mangohud.nix
    # ./prismlauncher.nix
  ];
  environment.systemPackages = with pkgs; [
    ryujinx
    heroic
    bottles
  ];
}
