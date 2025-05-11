{
  pkgs,
  terminal,
  ...
}: {
  fonts.packages = with pkgs.nerd-fonts; [jetbrains-mono];
  imports = [
    ../../themes/Catppuccin # Catppuccin GTK and QT themes
    ../hyprland/programs/dunst
    # ../hyprland/programs/dunst
  ];

  services.xserver = {
    enable = true;
    autorun = false;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
        dmenu
        rofi
        polybar
        cava
        # xorg.xrandr
        # edid-decode
        # vim.xxd
      ];
    };
  };
  home-manager.sharedModules = [
    (_: {
      imports = [./picom.nix];
      xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        config = {
          floating.criteria = [{class = "^Mpv$";}];
          gaps.smartBorders = "on";
          window.titlebar = false;
          window.hideEdgeBorders = "both";
          gaps = {
            inner = 4;
            outer = 6;
          };
          keybindings = import ./keybindings.nix {
            inherit pkgs terminal;
          };
          bars = [];
          startup = [
            {
              command = "systemctl --user restart picom";
              always = true;
              notification = false;
            }
            {
              command = "~/.config/polybar/scripts/polybar.sh";
              always = true;
              notification = false;
            }
            {
              command = "${pkgs.feh}/bin/feh --bg-fill --no-fehbg ${../../themes/wallpapers/escape_velocity.jxl}";
              always = false;
              notification = false;
            }
            {
              command = "dunst";
              always = false;
              notification = false;
            }
          ];
          defaultWorkspace = "workspace number 1";
          assigns = {
            # "1" = [
            #   {class = "^kitty$";}
            #   {class = "^Alacritty$";}
            #   {class = "^org.wezfurlong.wezterm$";}
            # ];
            # "2" = [
            #   {class = "^code$";}
            #   {class = "^VSCodium$";}
            #   {class = "^code-url-handler$";}
            #   {class = "^codium-url-handler$";}
            # ];
            # "3" = [
            #   {class = "^krita$";}
            #   {title = ".*Godot.*$";}
            #   {title = "GNU Image Manipulation Program.*$";}
            #   {class = "^factorio$";}
            #   {class = "^steam$";}
            # ];
            # "Web" = [
            #   # Hyprland used workspace 5
            #   {class = "^firefox$";}
            #   {class = "^floorp$";}
            #   {class = "^zen$";}
            # ];
            # "Music" = [
            #   {class = "^Spotify$";}
            #   {title = ".*Spotify.*$";}
            # ];
          };
        };
      };
      xdg.configFile."polybar".source = ./polybar;
    })
  ];
}
