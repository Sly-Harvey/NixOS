{ pkgs, host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) terminal browser defaultWallpaper;
in
{
  imports = [
    ../../themes/Catppuccin
    ../hyprland/programs/rofi
    ./dunst.nix
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
      imports = [ ./picom.nix ];
      xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        config = {
          floating.criteria = [ { class = "^Mpv$"; } ];
          gaps.smartBorders = "on";
          window.titlebar = false;
          window.hideEdgeBorders = "both";
          gaps = {
            inner = 4;
            outer = 4;
          };
          colors = {
            focused = {
              border = "#A4B9EF";
              background = "#A4B9EF";
              text = "#A4B9EF";
              indicator = "#A4B9EF";
              childBorder = "#A4B9EF";
            };
            unfocused = {
              border = "#1F1F31";
              background = "#1F1F31";
              text = "#1F1F31";
              indicator = "#1F1F31";
              childBorder = "#1F1F31";
            };
            focusedInactive = {
              border = "#1F1F31";
              background = "#1F1F31";
              text = "#1F1F31";
              indicator = "#1F1F31";
              childBorder = "#1F1F31";
            };
          };
          keybindings = import ./keybindings.nix {
            inherit pkgs terminal browser;
          };
          bars = [ ];
          startup = [
            {
              command = "${./monitors.sh}";
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
              command = "${./wallpaper.sh} ${../../themes/wallpapers/${defaultWallpaper}}";
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
            {
              workspace = "1";
              output = "DP-0";
            }
            {
              workspace = "2";
              output = "DP-0";
            }
            {
              workspace = "3";
              output = "DP-0";
            }
            {
              workspace = "4";
              output = "DP-0";
            }
            {
              workspace = "5";
              output = "HDMI-0";
            }
            {
              workspace = "6";
              output = "HDMI-0";
            }
            {
              workspace = "7";
              output = "HDMI-0";
            }
            {
              workspace = "8";
              output = "HDMI-1";
            }
            {
              workspace = "9";
              output = "HDMI-1";
            }
            {
              workspace = "10";
              output = "DP-0";
            }
          ];
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
