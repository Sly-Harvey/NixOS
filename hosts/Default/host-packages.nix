{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    ludusavi # For game saves
    proton-vpn # VPN
    github-desktop
    # pokego # Overlayed
  ];
}
