{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    protonvpn-gui # VPN
    github-desktop
    # pokego # Overlayed
  ];
}
