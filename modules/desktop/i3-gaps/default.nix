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
        feh
        dmenu
        rofi
        polybar
        cava
        xorg.xrandr
        edid-decode
        vim.xxd
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
              command = "~/.config/i3/monitors.sh";
              always = true;
              notification = false;
            }
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
              command = "~/.config/i3/wallpaper.sh";
              always = false;
              notification = false;
            }
            {
              command = "dunst";
              always = false;
              notification = false;
            }
          ];
          # defaultWorkspace = "workspace number 1";
          workspaceOutputAssign = [
            { workspace = "1"; output = "DP-0"; }
            { workspace = "2"; output = "DP-0"; }
            { workspace = "3"; output = "DP-0"; }
            { workspace = "4"; output = "DP-0"; }
            { workspace = "5"; output = "HDMI-0"; }
            { workspace = "6"; output = "HDMI-0"; }
            { workspace = "7"; output = "HDMI-0"; }
            { workspace = "8"; output = "HDMI-1"; }
            { workspace = "9"; output = "HDMI-1"; }
            { workspace = "10"; output = "DP-0"; }
          ];
          assigns = {
            # "1" = [
            #   {class = "^ghostty$";}
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
            # ];
            # "Music" = [
            #   {class = "^Spotify$";}
            #   {title = ".*Spotify.*$";}
            # ];
          };
        };
      };
      xdg.configFile."polybar".source = ./polybar;
      xdg.configFile."i3/monitors.sh" = {
        executable = true;
        source = ./monitors.sh;
      };
      xdg.configFile."i3/wallpaper.sh" = {
        executable = true;
        source = ./wallpaper.sh;
      };
      xdg.configFile."i3/wallpaper.jxl" = {
        executable = true;
        source = ../../themes/wallpapers/kurzgesagt.jxl;
      };
    })
  ];
}
