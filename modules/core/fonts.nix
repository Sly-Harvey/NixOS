{ pkgs, ... }:
{
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
  ];
}
