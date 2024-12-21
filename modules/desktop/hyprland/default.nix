{
  lib,
  pkgs,
  terminal,
  ...
}: {
  imports = [
    ../../themes/Catppuccin # Catppuccin GTK and QT themes
    ./programs/waybar
    ./programs/wlogout
    ./programs/rofi
    ./programs/dunst
    ./programs/hyprlock
    ./programs/swaync
  ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = true;
    # withUWSM = true;
    xwayland.enable = true;
  };

  home-manager.sharedModules = let
    inherit (lib) getExe getExe';
  in [
    ({...}: {
      home.packages = with pkgs; [
        # blueman
        hyprpaper
        cliphist
        grimblast
        libnotify
        light
        networkmanagerapplet
        pamixer
        pavucontrol
        playerctl
        slurp
        swappy
        swaynotificationcenter
        waybar
        wtype
        wl-clipboard
        xdotool
      ];

      xdg.configFile."hypr/scripts" = {
        source = ./scripts;
        recursive = true;
      };
      xdg.configFile."hypr/icons" = {
        source = ./icons;
        recursive = true;
      };

      #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        plugins = [
          # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
        ];
        systemd = {
          enable = true;
          variables = ["--all"];
        };
        settings = {
          "$scriptsDir" = "XDG_BIN_HOME";
          "$hyprScriptsDir" = "$XDG_CONFIG_HOME/hypr/scripts";
          "$mainMod" = "SUPER";
          # "$launcher" = "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window -theme $XDG_CONFIG_HOME/rofi/launchers/type-4/style-7.rasi";
          # "$launcher" = "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window -theme $XDG_CONFIG_HOME/rofi/launchers/type-4/style-3.rasi";
          "$launcher" = "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window -theme $XDG_CONFIG_HOME/rofi/launchers/type-2/style-2.rasi";
          "$term" = "${getExe pkgs.${terminal}}";
          "$editor" = "code --disable-gpu";
          "$file" = "$term -e lf";
          "$browser" = "firefox";

          env = [
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "GDK_BACKEND,wayland,x11,*"
            "NIXOS_OZONE_WL,1"
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
            "MOZ_ENABLE_WAYLAND,1"
            "OZONE_PLATFORM,wayland"
            "EGL_PLATFORM,wayland"
            "CLUTTER_BACKEND,wayland"
            "SDL_VIDEODRIVER,wayland"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_QPA_PLATFORMTHEME,qt6ct"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "WLR_RENDERER_ALLOW_SOFTWARE,1"
            "NIXPKGS_ALLOW_UNFREE,1"
          ];
          exec-once = [
            #"[workspace 1 silent] firefox"
            #"[workspace 2 silent] alacritty"
            #"[workspace 5 silent] spotify"
            #"[workspace special silent] firefox --new-instance -P private"
            #"[workspace special silent] alacritty"
            #"[workspace 8 silent] alacritty -e cava"
            #"[workspace 9 silent] alacritty -e cava"

            "hyprpaper"
            "sleep 1 && waybar"
            "swaync"
            "pamixer --set-volume 50"
            # "dunst"
            # "blueman-applet"
            "nm-applet --indicator"
            "wl-clipboard-history -t"
            "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store" # clipboard store text data
            "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store" # clipboard store image data
            "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
            "$hyprScriptsDir/batterynotify.sh" # battery notification
            "polkit-agent-helper-1"
            #"systemctl start --user polkit-kde-authentication-agent-1"
          ];
          input = {
            kb_layout = "gb,gb,ru";
            kb_variant = "extd,dvorak,";
            repeat_delay = 300; # or 212
            repeat_rate = 30;

            follow_mouse = 1;

            touchpad = {natural_scroll = false;};

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
            force_no_accel = true;
          };
          general = {
            gaps_in = 4;
            gaps_out = 9;
            border_size = 2;
            "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
            "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
            resize_on_border = true;
            layout = "master"; # dwindle or master
            # allow_tearing = true; # Allow tearing for games (use immediate window rules for specific games or all titles)
          };
          decoration = {
            shadow.enabled = false;
            rounding = 10;
            dim_special = 0.3;
            blur = {
              enabled = true;
              special = true;
              size = 6;
              passes = 3;
              new_optimizations = true;
              ignore_opacity = true;
              xray = false;
            };
          };
          group = {
            "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
            "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
            "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
            "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
          };
          layerrule = [
            "blur, rofi"
            "ignorezero, rofi"
            "ignorealpha 0.7, rofi"

            "blur, swaync-control-center"
            "blur, swaync-notification-window"
            "ignorezero, swaync-control-center"
            "ignorezero, swaync-notification-window"
            "ignorealpha 0.7, swaync-control-center"
            # "ignorealpha 0.8, swaync-notification-window"
            # "dimaround, swaync-control-center"
          ];
          animations = {
            enabled = true;
            bezier = [
              "linear, 0, 0, 1, 1"
              "md3_standard, 0.2, 0, 0, 1"
              "md3_decel, 0.05, 0.7, 0.1, 1"
              "md3_accel, 0.3, 0, 0.8, 0.15"
              "overshot, 0.05, 0.9, 0.1, 1.1"
              "crazyshot, 0.1, 1.5, 0.76, 0.92"
              "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
              "fluent_decel, 0.1, 1, 0, 1"
              "easeInOutCirc, 0.85, 0, 0.15, 1"
              "easeOutCirc, 0, 0.55, 0.45, 1"
              "easeOutExpo, 0.16, 1, 0.3, 1"
            ];
            animation = [
              "windows, 1, 3, md3_decel, popin 60%"
              "border, 1, 10, default"
              "fade, 1, 2.5, md3_decel"
              # "workspaces, 1, 3.5, md3_decel, slide"
              "workspaces, 1, 3.5, easeOutExpo, slide"
              # "workspaces, 1, 7, fluent_decel, slidefade 15%"
              # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
              "specialWorkspace, 1, 3, md3_decel, slidevert"
            ];
          };
          render = {
            explicit_sync = 2; # 0 = off, 1 = on, 2 = auto based on gpu driver.
            explicit_sync_kms = 2; # 0 = off, 1 = on, 2 = auto based on gpu driver.
            direct_scanout = false; # Set to true for less Fullscreen game lag (may cause glitches).
          };
          misc = {
            disable_hyprland_logo = true;
            mouse_move_focuses_monitor = true;
            vfr = true; # always keep on
            vrr = 1; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only)
          };
          xwayland.force_zero_scaling = true;
          gestures = {
            workspace_swipe = true;
            workspace_swipe_fingers = 3;
          };
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };
          master = {
            new_status = "master";
            new_on_top = true;
            mfact = 0.5;
          };
          windowrulev2 = [
            #"noanim, class:^(Rofi)$
            "tile,title:(.*)(Godot)(.*)$"
            "workspace 1, class:^(kitty)$"
            "workspace 1, class:^(Alacritty)$"
            "workspace 2, class:^(VSCodium)$"
            "workspace 2, class:^(codium-url-handler)$"
            "workspace 2, class:^(Code)$"
            "workspace 2, class:^(code-url-handler)$"
            "workspace 3, class:^(krita)$"
            "workspace 3, title:(.*)(Godot)(.*)$"
            "workspace 3, title:(GNU Image Manipulation Program)(.*)$"
            "workspace 3, class:^(factorio)$"
            "workspace 3, class:^(steam)$"
            "workspace 5, class:^(firefox)$"
            "workspace 6, class:^(Spotify)$"
            "workspace 6, title:(.*)(Spotify)(.*)$"
            "workspace 8, class:^(kitty-rebuildScript)$"

            "opacity 0.80 0.80,class:^(alacritty)$"
            "opacity 1.00 1.00,class:^(firefox)$"
            "opacity 0.90 0.90,class:^(Brave-browser)$"
            "opacity 0.80 0.80,class:^(Steam)$"
            "opacity 0.80 0.80,class:^(steam)$"
            "opacity 0.80 0.80,class:^(steamwebhelper)$"
            "opacity 0.80 0.80,class:^(Spotify)$"
            "opacity 0.80 0.80,title:(.*)(Spotify)(.*)$"
            # "opacity 0.80 0.80,class:^(VSCodium)$"
            # "opacity 0.80 0.80,class:^(codium-url-handler)$"
            "opacity 0.80 0.80,class:^(Code)$"
            "opacity 0.80 0.80,class:^(code-url-handler)$"
            "opacity 0.80 0.80,class:^(kitty)$"
            "opacity 0.80 0.80,class:^(kitty-rebuildScript)$"
            "opacity 0.80 0.80,class:^(org.kde.dolphin)$"
            "opacity 0.80 0.80,class:^(org.kde.ark)$"
            "opacity 0.80 0.80,class:^(nwg-look)$"
            "opacity 0.80 0.80,class:^(qt5ct)$"
            "opacity 0.80 0.80,class:^(qt6ct)$"

            "opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$" #Clapper-Gtk
            "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$" #Flatseal-Gtk
            "opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$" #Cartridges-Gtk
            "opacity 0.80 0.80,class:^(com.obsproject.Studio)$" #Obs-Qt
            "opacity 0.80 0.80,class:^(gnome-boxes)$" #Boxes-Gtk
            "opacity 0.80 0.80,class:^(discord)$" #Discord-Electron
            "opacity 0.80 0.80,class:^(WebCord)$" #WebCord-Electron
            "opacity 0.80 0.80,class:^(app.drey.Warp)$" #Warp-Gtk
            "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$" #ProtonUp-Qt
            "opacity 0.80 0.80,class:^(yad)$" #Protontricks-Gtk
            "opacity 0.80 0.80,class:^(Signal)$" #Signal-Gtk
            "opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$" #Upscaler-Gtk

            "opacity 0.80 0.70,class:^(pavucontrol)$"
            "opacity 0.80 0.70,class:^(blueman-manager)$"
            "opacity 0.80 0.70,class:^(nm-applet)$"
            "opacity 0.80 0.70,class:^(nm-connection-editor)$"
            "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"

            "float,class:^(qt5ct)$"
            "float,class:^(nwg-look)$"
            "float,class:^(org.kde.ark)$"
            "float,class:^(Signal)$" #Signal-Gtk
            "float,class:^(com.github.rafostar.Clapper)$" #Clapper-Gtk
            "float,class:^(app.drey.Warp)$" #Warp-Gtk
            "float,class:^(net.davidotek.pupgui2)$" #ProtonUp-Qt
            "float,class:^(yad)$" #Protontricks-Gtk
            "float,class:^(eog)$" #Imageviewer-Gtk
            "float,class:^(io.gitlab.theevilskeleton.Upscaler)$" #Upscaler-Gtk
            "float,class:^(pavucontrol)$"
            "float,class:^(blueman-manager)$"
            "float,class:^(nm-applet)$"
            "float,class:^(nm-connection-editor)$"
            "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          ];
          binde = [
            # Resize windows
            "$mainMod SHIFT, right, resizeactive, 30 0"
            "$mainMod SHIFT, left, resizeactive, -30 0"
            "$mainMod SHIFT, up, resizeactive, 0 -30"
            "$mainMod SHIFT, down, resizeactive, 0 30"

            # Resize windows with hjkl keys
            "$mainMod SHIFT, l, resizeactive, 30 0"
            "$mainMod SHIFT, h, resizeactive, -30 0"
            "$mainMod SHIFT, k, resizeactive, 0 -30"
            "$mainMod SHIFT, j, resizeactive, 0 30"

            # Functional keybinds
            ",XF86MonBrightnessDown,exec,light -U 20"
            ",XF86MonBrightnessUp,exec,light -A 20"
            ",XF86AudioLowerVolume,exec,pamixer -d 2"
            ",XF86AudioRaiseVolume,exec,pamixer -i 2"
          ];
          bind =
            [
              # Night Mode (lower value means warmer temp)
              "$mainMod, F9, exec, ${getExe pkgs.wlsunset} -t 3000 -T 3900"
              "$mainMod, F10, exec, pkill wlsunset"

              # Window/Session actions
              "$mainMod, Q, exec, $hyprScriptsDir/dontkillsteam.sh" # killactive, kill the window on focus
              "ALT, F4, exec, $hyprScriptsDir/dontkillsteam.sh" # killactive, kill the window on focus
              "$mainMod, delete, exit" # kill hyperland session
              "$mainMod, W, togglefloating" # toggle the window on focus to float
              "$mainMod SHIFT, G, togglegroup" # toggle the window on focus to float
              "ALT, return, fullscreen" # toggle the window on focus to fullscreen
              "$mainMod ALT, L, exec, hyprlock" # lock screen
              "$mainMod, backspace, exec, wlogout -b 4" # logout menu
              "$CONTROL, ESCAPE, exec, killall waybar || waybar" # toggle waybar

              "$mainMod, Return, exec, $term"
              "$mainMod, T, exec, $term"
              "$mainMod, E, exec, $file"
              "$mainMod, C, exec, $editor"
              "$mainMod, F, exec, $browser"
              "$CONTROL ALT, DELETE, exec, $term -e '${getExe pkgs.btop}'" # system monitor

              "$mainMod, A, exec, pkill -x rofi || $launcher" # launch desktop applications
              "$mainMod, SPACE, exec, pkill -x rofi || $launcher" # launch desktop applications
              "$mainMod, Z, exec, pkill -x rofi || $hyprScriptsDir/emoji.sh" # launch emoji picker
              #"$mainMod, tab, exec, pkill -x rofi || $hyprScriptsDir/rofilaunch.sh w" # switch between desktop applications
              # "$mainMod, R, exec, pkill -x rofi || $hyprScriptsDir/rofilaunch.sh f" # browse system files
              "$mainMod ALT, K, exec, $hyprScriptsDir/keyboardswitch.sh" # change keyboard layout
              "$mainMod SHIFT, N, exec, swaync-client -t -sw" # swayNC panel
              "$mainMod SHIFT, Q, exec, swaync-client -t -sw" # swayNC panel
              "$mainMod, G, exec, $hyprScriptsDir/gamelauncher.sh" # game launcher
              "$mainMod ALT, G, exec, $hyprScriptsDir/gamemode.sh" # disable hypr effects for gamemode
              "$mainMod, V, exec, $hyprScriptsDir/ClipManager.sh" # Clipboard Manager
              "$mainMod, M, exec, pkill -x rofi || $hyprScriptsDir/rofimusic.sh" # online music
              "$mainMod SHIFT, M, exec, pkill -x rofi || $hyprScriptsDir/rofimusic.sh" # online music

              # Screenshot/Screencapture
              "$mainMod, P, exec, $hyprScriptsDir/screenshot.sh s" # drag to snip an area / click on a window to print it
              "$mainMod CTRL, P, exec, $hyprScriptsDir/screenshot.sh sf" # frozen screen, drag to snip an area / click on a window to print it
              "$mainMod, print, exec, $hyprScriptsDir/screenshot.sh m" # print focused monitor
              "$mainMod ALT, P, exec, $hyprScriptsDir/screenshot.sh p" # print all monitor outputs

              # Functional keybinds
              ",xf86Sleep, exec, systemctl suspend" # Put computer into sleep mode
              ",XF86AudioMicMute,exec,pamixer --default-source -t" # mute mic
              ",XF86AudioMute,exec,pamixer -t" # mute audio
              ",XF86AudioPlay,exec,playerctl play-pause" # Play/Pause media
              ",XF86AudioPause,exec,playerctl play-pause" # Play/Pause media
              ",xf86AudioNext,exec,playerctl next" # go to next media
              ",xf86AudioPrev,exec,playerctl previous" # go to previous media
              # ",xf86AudioNext,exec,$hyprScriptsDir/MediaCtrl.sh --nxt" # go to next media
              # ",xf86AudioPrev,exec,$hyprScriptsDir/MediaCtrl.sh --prv" # go to previous media

              # to switch between windows in a floating workspace
              "SUPER,Tab,cyclenext"
              "SUPER,Tab,bringactivetotop"

              # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
              "$mainMod CTRL, right, workspace, r+1"
              "$mainMod CTRL, left, workspace, r-1"

              # move to the first empty workspace instantly with mainMod + CTRL + [↓]
              "$mainMod CTRL, down, workspace, empty"

              # Move focus with mainMod + arrow keys
              "$mainMod, left, movefocus, l"
              "$mainMod, right, movefocus, r"
              "$mainMod, up, movefocus, u"
              "$mainMod, down, movefocus, d"
              "ALT, Tab, movefocus, d"

              # Move focus with mainMod + HJKL keys
              "$mainMod, h, movefocus, l"
              "$mainMod, l, movefocus, r"
              "$mainMod, k, movefocus, u"
              "$mainMod, j, movefocus, d"

              # Go to workspace 5 (FireFox) and 6 (Spotify) with mouse side buttons
              "$mainMod, mouse:276, workspace, 5"
              "$mainMod, mouse:275, workspace, 6"
              "$mainMod SHIFT, mouse:276, movetoworkspace, 5"
              "$mainMod SHIFT, mouse:275, movetoworkspace, 6"
              "$mainMod CTRL, mouse:276, movetoworkspacesilent, 5"
              "$mainMod CTRL, mouse:275, movetoworkspacesilent, 6"

              # Rebuild NixOS with a KeyBind
              "$mainMod CTRL ALT, KP_Divide, exec, kitty --class \"kitty-rebuildScript\" $hyprScriptsDir/rebuild.sh"

              # Scroll through existing workspaces with mainMod + scroll
              "$mainMod, mouse_down, workspace, e+1"
              "$mainMod, mouse_up, workspace, e-1"

              # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
              "$mainMod CTRL ALT, right, movetoworkspace, r+1"
              "$mainMod CTRL ALT, left, movetoworkspace, r-1"

              # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
              "$mainMod SHIFT $CONTROL, left, movewindow, l"
              "$mainMod SHIFT $CONTROL, right, movewindow, r"
              "$mainMod SHIFT $CONTROL, up, movewindow, u"
              "$mainMod SHIFT $CONTROL, down, movewindow, d"

              # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
              "$mainMod SHIFT $CONTROL, H, movewindow, l"
              "$mainMod SHIFT $CONTROL, L, movewindow, r"
              "$mainMod SHIFT $CONTROL, K, movewindow, u"
              "$mainMod SHIFT $CONTROL, J, movewindow, d"

              # Special workspaces (scratchpad)
              "$mainMod CTRL, S, movetoworkspacesilent, special"
              "$mainMod ALT, S, movetoworkspacesilent, special"
              "$mainMod, S, togglespecialworkspace,"
            ]
            ++ (builtins.concatLists (builtins.genList (x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                "$mainMod CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ])
              10));
          bindm = [
            # Move/Resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };
        extraConfig = ''
          binds {
            workspace_back_and_forth = 1
            #allow_workspace_cycles=1
            #pass_mouse_when_bound=0
          }

          # Easily plug in any monitor
          monitor=,preferred,auto,1

          # 1080p-HDR monitor on the left, 4K-HDR monitor in the middle and 1080p vertical monitor on the right.
          monitor=desc:BNQ BenQ EW277HDR 99J01861SL0,preferred,-1920x0,1,bitdepth,8
          monitor=desc:BNQ BenQ EL2870U PCK00489SL0,3840x2160@60,0x0,2,bitdepth,10,vrr,1
          monitor=desc:BNQ BenQ xl2420t 99D06760SL0,preferred,1920x0,1,transform,1 # 5 for fipped

          workspace=1,monitor:desc:BNQ BenQ EL2870U PCK00489SL0,default:true
          workspace=2,monitor:desc:BNQ BenQ EL2870U PCK00489SL0
          workspace=3,monitor:desc:BNQ BenQ EL2870U PCK00489SL0
          workspace=4,monitor:desc:BNQ BenQ EL2870U PCK00489SL0
          workspace=5,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0,default:true
          workspace=6,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0
          workspace=7,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0
          workspace=8,monitor:desc:BNQ BenQ xl2420t 99D06760SL0,default:true
          workspace=9,monitor:desc:BNQ BenQ xl2420t 99D06760SL0
          workspace=10,monitor:desc:BNQ BenQ EL2870U PCK00489SL0
        '';
      };
    })
  ];
}
