{
  pkgs,
  ...
}:
{
  imports = [
    ./dconf.nix
  ];
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    #layout = "gb";
    #libinput = { touchpad.tapping = true; };
  };
  services.gnome.gnome-initial-setup.enable = false;
  services.gnome.games.enable = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    #gnome-backgrounds
    #pkgs.gnome-video-effects
    gnome-maps
    gnome-music
    pkgs.gnome-tour
    pkgs.gnome-text-editor
    pkgs.gnome-user-docs
  ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.burn-my-windows
    gnomeExtensions.compact-top-bar
    gnomeExtensions.custom-accent-colors
    gradience
    gnomeExtensions.gtile
    gnomeExtensions.dash-to-panel
    gnomeExtensions.tray-icons-reloaded
    gnome.gnome-tweaks
    gnomeExtensions.arcmenu
    gnomeExtensions.gesture-improvements
    gnomeExtensions.paperwm
    gnomeExtensions.just-perfection
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.vitals
  ];
}
