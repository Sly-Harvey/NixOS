{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin # Archive management
      thunar-volman # Volume management (automount removable devices)
      thunar-media-tags-plugin # Tagging & renaming feature for media files
    ];
  };
  # Archive manager
  environment.systemPackages = with pkgs; [ file-roller ];
}
