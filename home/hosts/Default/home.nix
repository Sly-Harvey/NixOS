{
  pkgs,
  username,
  ...
}: {
  imports = [
    #../../programs
    #../../themes
    #../../wallpapers
    ../common.nix
    ../../programs/hyprland # use Hyprland window manager
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  # ADD USER PACKAGES HERE (Add system packages in /system/hosts/Default/configuration.nix)
  home.packages = with pkgs; [

  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
