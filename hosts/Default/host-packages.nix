{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # obsidian
    # ludusavi
    # godot
    # proton-vpn
    # github-desktop
    # pokego # Overlayed
  ];
}
