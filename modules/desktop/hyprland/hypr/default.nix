{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../../themes/Catppuccin # Catppuccin GTK and QT themes
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  home-manager.users.${username} = {...}: {
    imports = [
      inputs.hyprland.homeManagerModules.default
      ./hyprland-environment.nix
    ];

    home.packages = with pkgs; [
      # blueman
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
      swww
      swaynotificationcenter
      waybar
      wlsunset
      # wl-clipboard
    ];

    home.file.".config/hypr/scripts" = {
      source = ./scripts;
      recursive = true;
    };
    home.file.".config/hypr/icons" = {
      source = ./icons;
      recursive = true;
    };

    #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      ];
      systemd = {
        enable = true;
        variables = ["--all"];
      };
      xwayland.enable = true;
      extraConfig = ''
        $scriptsDir = $HOME/.local/bin
        $hyprScriptsDir = $HOME/.config/hypr/scripts

        plugin {
          overview {
            showEmptyWorkspace = true
            panelHeight = 200
            overrideGaps = true
            gapsIn = 6
            gapsOut = 13
          }
        }

        # Monitor
        monitor=HDMI-A-2,1920x1080@60.0,1920x0,1.0
        # monitor=HDMI-A-2,disable
        monitor=HDMI-A-1,1920x1080@60.0,0x0,1.0

        # Autostart
        exec-once = pamixer --set-volume 40
        #exec-once = [workspace 1 silent] firefox
        #exec-once = [workspace 2 silent] alacritty
        #exec-once = [workspace 5 silent] spotify
        #exec-once = [workspace special silent] firefox --new-instance -P private
        #exec-once = [workspace special silent] alacritty
        #exec-once = [workspace 8 silent] alacritty -e cava
        #exec-once = [workspace 9 silent] alacritty -e cava

        exec-once = ~/.config/hypr/scripts/wallpaper.sh
        exec-once = waybar &
        exec-once = swaync &
        # exec-once = dunst
        # exec-once = blueman-applet
        exec-once = nm-applet --indicator
        exec-once = wl-clipboard-history -t
        exec-once = wl-paste --type text --watch cliphist store # clipboard store text data
        exec-once = wl-paste --type image --watch cliphist store # clipboard store image data
        exec-once = rm "$HOME/.cache/cliphist/db" # Clear clipboard
        exec-once = $hyprScriptsDir/batterynotify.sh # battery notification
        exec-once = polkit-agent-helper-1
        #exec-once = systemctl start --user polkit-kde-authentication-agent-1

        source = ~/.config/hypr/colors

        # Input config
        input {
            kb_layout = gb,gb,de,fr
            kb_variant = extd,dvorak,,
            repeat_delay = 212
            repeat_rate = 30
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            touchpad {
                natural_scroll = false
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            force_no_accel = 1
        }

        gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
        }

        binds {
            workspace_back_and_forth=1
            #allow_workspace_cycles=1
            #pass_mouse_when_bound=0
        }

        general {
            gaps_in = 3
            gaps_out = 8
            border_size = 2
            col.active_border = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
            col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg
            resize_on_border = true
            layout = master # dwindle or master
            #allow_tearing = true
        }

        group {
            col.border_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
            col.border_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
            col.border_locked_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
            col.border_locked_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
        }

        misc {
            disable_hyprland_logo = true
            mouse_move_focuses_monitor = true
            vfr = 1 # always keep on
            vrr = 1 # enable variable refresh rate (effective depending on hardware)
            no_direct_scanout = false; # Set to false for improved Fullscreen performance.
        }

        animations {
          enabled = true
          # Animation curves

          bezier = linear, 0, 0, 1, 1
          bezier = md3_standard, 0.2, 0, 0, 1
          bezier = md3_decel, 0.05, 0.7, 0.1, 1
          bezier = md3_accel, 0.3, 0, 0.8, 0.15
          bezier = overshot, 0.05, 0.9, 0.1, 1.1
          bezier = crazyshot, 0.1, 1.5, 0.76, 0.92
          bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
          bezier = fluent_decel, 0.1, 1, 0, 1
          bezier = easeInOutCirc, 0.85, 0, 0.15, 1
          bezier = easeOutCirc, 0, 0.55, 0.45, 1
          bezier = easeOutExpo, 0.16, 1, 0.3, 1
          # Animation configs
          animation = windows, 1, 3, md3_decel, popin 60%
          animation = border, 1, 10, default
          animation = fade, 1, 2.5, md3_decel
          # animation = workspaces, 1, 3.5, md3_decel, slide
          animation = workspaces, 1, 3.5, easeOutExpo, slide
          # animation = workspaces, 1, 7, fluent_decel, slidefade 15%
          # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
          animation = specialWorkspace, 1, 3, md3_decel, slidevert
        }

        decoration {
            rounding = 10
            drop_shadow = false
            dim_special = 0.3
            blur {
                enabled = yes
                special = true
                size = 6
                passes = 3
                new_optimizations = on
                ignore_opacity = on
                xray = false
            }
        }

        dwindle {
            pseudotile = yes
            preserve_split = yes
        }

        master {
            new_is_master = yes
            new_on_top=1
            mfact = 0.5
        }

        gestures {
            workspace_swipe = false
        }

        workspace=1,monitor:HDMI-A-1,default:true
        workspace=2,monitor:HDMI-A-2,default:true
        workspace=3,monitor:HDMI-A-2
        workspace=4,monitor:HDMI-A-2
        workspace=5,monitor:HDMI-A-1
        workspace=7,monitor:HDMI-A-1
        workspace=8,monitor:HDMI-A-1
        workspace=9,monitor:HDMI-A-2
        workspace=10,monitor:HDMI-A-2

        # Example windowrule v1
        # windowrule = float, ^(kitty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

        #windowrulev2 = noanim, class:^(Rofi)$
        windowrulev2 = opacity 0.80 0.80,class:^(alacritty)$
        windowrulev2 = tile,title:(.*)(Godot)(.*)$
        windowrulev2 = workspace 1, class:^(firefox)$
        windowrulev2 = workspace 2, class:^(Alacritty)$
        windowrulev2 = workspace 2, class:^(kitty)$
        windowrulev2 = workspace 3, class:^(VSCodium)$
        windowrulev2 = workspace 3, class:^(codium-url-handler)$
        windowrulev2 = workspace 3, class:^(Code)$
        windowrulev2 = workspace 3, class:^(code-url-handler)$
        windowrulev2 = workspace 4, class:^(krita)$
        windowrulev2 = workspace 4, title:(.*)(Godot)(.*)$
        windowrulev2 = workspace 4, title:(GNU Image Manipulation Program)(.*)$
        windowrulev2 = workspace 5, class:^(Spotify)$
        windowrulev2 = workspace 5, title:(.*)(Spotify)(.*)$
        windowrulev2 = workspace 7, class:^(steam)$
        # windowrulev2 = workspace 10, class:^(factorio)$

        # Allow screen tearing for reduced input latency on some games.
        #windowrulev2 = immediate, class:^(cs2)$
        #windowrulev2 = immediate, class:^(steam_app_0)$
        #windowrulev2 = immediate, class:^(steam_app_1)$
        #windowrulev2 = immediate, class:^(steam_app_2)$
        #windowrulev2 = immediate, class:^(.*)(.exe)$

        windowrulev2 = opacity 1.00 1.00,class:^(firefox)$
        windowrulev2 = opacity 0.90 0.90,class:^(Brave-browser)$
        windowrulev2 = opacity 0.80 0.80,class:^(Steam)$
        windowrulev2 = opacity 0.80 0.80,class:^(steam)$
        windowrulev2 = opacity 0.80 0.80,class:^(steamwebhelper)$
        windowrulev2 = opacity 0.80 0.80,class:^(Spotify)$
        windowrulev2 = opacity 0.80 0.80,title:(.*)(Spotify)(.*)$
        # windowrulev2 = opacity 0.80 0.80,class:^(VSCodium)$
        # windowrulev2 = opacity 0.80 0.80,class:^(codium-url-handler)$
        windowrulev2 = opacity 0.80 0.80,class:^(Code)$
        windowrulev2 = opacity 0.80 0.80,class:^(code-url-handler)$
        windowrulev2 = opacity 0.80 0.80,class:^(kitty)$
        windowrulev2 = opacity 0.80 0.80,class:^(org.kde.dolphin)$
        windowrulev2 = opacity 0.80 0.80,class:^(org.kde.ark)$
        windowrulev2 = opacity 0.80 0.80,class:^(nwg-look)$
        windowrulev2 = opacity 0.80 0.80,class:^(qt5ct)$

        windowrulev2 = opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$ #Clapper-Gtk
        windowrulev2 = opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$ #Flatseal-Gtk
        windowrulev2 = opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$ #Cartridges-Gtk
        windowrulev2 = opacity 0.80 0.80,class:^(com.obsproject.Studio)$ #Obs-Qt
        windowrulev2 = opacity 0.80 0.80,class:^(gnome-boxes)$ #Boxes-Gtk
        windowrulev2 = opacity 0.80 0.80,class:^(discord)$ #Discord-Electron
        windowrulev2 = opacity 0.80 0.80,class:^(WebCord)$ #WebCord-Electron
        windowrulev2 = opacity 0.80 0.80,class:^(app.drey.Warp)$ #Warp-Gtk
        windowrulev2 = opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$ #ProtonUp-Qt
        windowrulev2 = opacity 0.80 0.80,class:^(yad)$ #Protontricks-Gtk
        windowrulev2 = opacity 0.80 0.80,class:^(Signal)$ #Signal-Gtk
        windowrulev2 = opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$ #Upscaler-Gtk

        windowrulev2 = opacity 0.80 0.70,class:^(pavucontrol)$
        windowrulev2 = opacity 0.80 0.70,class:^(blueman-manager)$
        windowrulev2 = opacity 0.80 0.70,class:^(nm-applet)$
        windowrulev2 = opacity 0.80 0.70,class:^(nm-connection-editor)$
        windowrulev2 = opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$

        windowrulev2 = float,class:^(qt5ct)$
        windowrulev2 = float,class:^(nwg-look)$
        windowrulev2 = float,class:^(org.kde.ark)$
        windowrulev2 = float,class:^(Signal)$ #Signal-Gtk
        windowrulev2 = float,class:^(com.github.rafostar.Clapper)$ #Clapper-Gtk
        windowrulev2 = float,class:^(app.drey.Warp)$ #Warp-Gtk
        windowrulev2 = float,class:^(net.davidotek.pupgui2)$ #ProtonUp-Qt
        windowrulev2 = float,class:^(yad)$ #Protontricks-Gtk
        windowrulev2 = float,class:^(eog)$ #Imageviewer-Gtk
        windowrulev2 = float,class:^(io.gitlab.theevilskeleton.Upscaler)$ #Upscaler-Gtk
        windowrulev2 = float,class:^(pavucontrol)$
        windowrulev2 = float,class:^(blueman-manager)$
        windowrulev2 = float,class:^(nm-applet)$
        windowrulev2 = float,class:^(nm-connection-editor)$
        windowrulev2 = float,class:^(org.kde.polkit-kde-authentication-agent-1)$

        $mainMod = SUPER
        $launcher = pkill rofi || rofi -show drun -modi drun,filebrowser,run,window -theme ~/.config/rofi/launchers/type-2/style-2.rasi
        $term = alacritty
        $editor = codium --disable-gpu
        $file = $term -e lf
        $browser = firefox

        # Night Mode (lower value means warmer temp)
        bind = $mainMod, F9, exec, wlsunset -t 3000 -T 3900
        bind = $mainMod, F10, exec, pkill wlsunset

        # Overview plugin
        bind = $mainMod, tab, overview:toggle

        # Window/Session actions
        bind = $mainMod, Q, exec, ~/.config/hypr/scripts/dontkillsteam.sh # killactive, kill the window on focus
        bind = ALT, F4, exec, ~/.config/hypr/scripts/dontkillsteam.sh # killactive, kill the window on focus
        bind = $mainMod, delete, exit # kill hyperland session
        bind = $mainMod, W, togglefloating # toggle the window on focus to float
        bind = $mainMod SHIFT, G, togglegroup # toggle the window on focus to float
        bind = ALT, return, fullscreen # toggle the window on focus to fullscreen
        #bind = $mainMod ALT, L, exec, swaylock # lock screen
        bind = $mainMod, backspace, exec, wlogout # logout menu
        bind = $CONTROL, ESCAPE, exec, killall waybar || waybar # toggle waybar

        bind = $mainMod, Return, exec, $term
        bind = $mainMod, T, exec, $term
        bind = $mainMod, E, exec, $file
        bind = $mainMod, C, exec, $editor
        bind = $mainMod, F, exec, $browser
        bind = $CONTROL ALT, DELETE, exec, $term -e "${pkgs.btop}/bin/btop"

        bind = $mainMod, A, exec, pkill -x rofi || $launcher # launch desktop applications
        #bind = $mainMod, tab, exec, pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh w # switch between desktop applications
        bind = $mainMod, R, exec, pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh f # browse system files
        bind = $mainMod SHIFT, W, exec, $hyprScriptsDir/WallpaperSelect.sh # Select wallpaper to apply
        bind = $mainMod, K, exec, $hyprScriptsDir/keyboardswitch.sh # change keyboard layout
        bind = $mainMod SHIFT, N, exec, swaync-client -t -sw # swayNC panel
        bind = $mainMod, G, exec, $hyprScriptsDir/gamelauncher.sh # game launcher
        bind = $mainMod ALT, G, exec, $hyprScriptsDir/gamemode.sh # disable hypr effects for gamemode
        bind = $mainMod, V, exec, $hyprScriptsDir/ClipManager.sh # Clipboard Manager
        bind = $mainMod SHIFT, M, exec, $hyprScriptsDir/rofimusic.sh # online music

        # Waybar
        bind = $mainMod, B, exec, killall -SIGUSR1 waybar # Toggle hide/show waybar
        bind = $mainMod CTRL, B, exec, $hyprScriptsDir/WaybarStyles.sh # Waybar Styles Menu
        bind = $mainMod ALT, B, exec, $hyprScriptsDir/WaybarLayout.sh # Waybar Layout Menu

        # Screenshot/Screencapture
        bind = $mainMod, P, exec, $hyprScriptsDir/screenshot.sh s # drag to snip an area / click on a window to print it
        bind = $mainMod CTRL, P, exec, $hyprScriptsDir/screenshot.sh sf # frozen screen, drag to snip an area / click on a window to print it
        bind = ,print, exec, $hyprScriptsDir/screenshot.sh m # print focused monitor
        bind = $mainMod ALT, P, exec, $hyprScriptsDir/screenshot.sh p  # print all monitor outputs

        # Functional keybinds
        bind =,xf86Sleep, exec, systemctl suspend
        bind =,XF86AudioMicMute,exec,pamixer --default-source -t
        bind =,XF86MonBrightnessDown,exec,light -U 20
        bind =,XF86MonBrightnessUp,exec,light -A 20
        bind =,XF86AudioMute,exec,pamixer -t
        bind =,XF86AudioLowerVolume,exec,pamixer -d 5
        bind =,XF86AudioRaiseVolume,exec,pamixer -i 5
        bind =,XF86AudioPlay,exec,playerctl play-pause
        bind =,XF86AudioPause,exec,playerctl play-pause
        bind =,xf86AudioNext,exec,playerctl next
        bind =,xf86AudioPrev,exec,playerctl previous
        # bind =,xf86AudioNext,exec,$hyprScriptsDir/MediaCtrl.sh --nxt
        # bind =,xf86AudioPrev,exec,$hyprScriptsDir/MediaCtrl.sh --prv

        # to switch between windows in a floating workspace
        # bind = SUPER,Tab,cyclenext,
        # bind = SUPER,Tab,bringactivetotop,

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10
        bind = $mainMod, mouse:275, workspace, 5

        # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
        bind = $mainMod CTRL, right, workspace, r+1
        bind = $mainMod CTRL, left, workspace, r-1

        # move to the first empty workspace instantly with mainMod + CTRL + [↓]
        bind = $mainMod CTRL, down, workspace, empty

        # Move focus with mainMod + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d
        bind = ALT, Tab, movefocus, d

        # Move focus with mainMod + HJKL keys
        bind = $mainMod, h, movefocus, l
        bind = $mainMod, l, movefocus, r
        bind = $mainMod, k, movefocus, u
        bind = $mainMod, j, movefocus, d

        # Resize windows
        binde = $mainMod SHIFT, right, resizeactive, 30 0
        binde = $mainMod SHIFT, left, resizeactive, -30 0
        binde = $mainMod SHIFT, up, resizeactive, 0 -30
        binde = $mainMod SHIFT, down, resizeactive, 0 30

        # Resize windows with hjkl keys
        binde = $mainMod SHIFT, l, resizeactive, 30 0
        binde = $mainMod SHIFT, h, resizeactive, -30 0
        binde = $mainMod SHIFT, k, resizeactive, 0 -30
        binde = $mainMod SHIFT, j, resizeactive, 0 30

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Move window silently to workspace Super + Alt + [0-9]
        bind = $mainMod ALT, 1, movetoworkspacesilent, 1
        bind = $mainMod ALT, 2, movetoworkspacesilent, 2
        bind = $mainMod ALT, 3, movetoworkspacesilent, 3
        bind = $mainMod ALT, 4, movetoworkspacesilent, 4
        bind = $mainMod ALT, 5, movetoworkspacesilent, 5
        bind = $mainMod ALT, 6, movetoworkspacesilent, 6
        bind = $mainMod ALT, 7, movetoworkspacesilent, 7
        bind = $mainMod ALT, 8, movetoworkspacesilent, 8
        bind = $mainMod ALT, 9, movetoworkspacesilent, 9
        bind = $mainMod ALT, 0, movetoworkspacesilent, 10

        # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
        bind = $mainMod CTRL ALT, right, movetoworkspace, r+1
        bind = $mainMod CTRL ALT, left, movetoworkspace, r-1

        # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
        bind = $mainMod SHIFT $CONTROL, left, movewindow, l
        bind = $mainMod SHIFT $CONTROL, right, movewindow, r
        bind = $mainMod SHIFT $CONTROL, up, movewindow, u
        bind = $mainMod SHIFT $CONTROL, down, movewindow, d

        # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
        bind = $mainMod SHIFT $CONTROL, H, movewindow, l
        bind = $mainMod SHIFT $CONTROL, L, movewindow, r
        bind = $mainMod SHIFT $CONTROL, K, movewindow, u
        bind = $mainMod SHIFT $CONTROL, J, movewindow, d

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/Resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        # Special workspaces (scratchpad)
        bind = $mainMod ALT, S, movetoworkspacesilent, special
        bind = $mainMod, S, togglespecialworkspace,
      '';
    };

    home.file.".config/hypr/colors".text = ''
      $background = rgba(1d192bee)
      $foreground = rgba(c3dde7ee)

      $color0 = rgba(1d192bee)
      $color1 = rgba(465EA7ee)
      $color2 = rgba(5A89B6ee)
      $color3 = rgba(6296CAee)
      $color4 = rgba(73B3D4ee)
      $color5 = rgba(7BC7DDee)
      $color6 = rgba(9CB4E3ee)
      $color7 = rgba(c3dde7ee)
      $color8 = rgba(889aa1ee)
      $color9 = rgba(465EA7ee)
      $color10 = rgba(5A89B6ee)
      $color11 = rgba(6296CAee)
      $color12 = rgba(73B3D4ee)
      $color13 = rgba(7BC7DDee)
      $color14 = rgba(9CB4E3ee)
      $color15 = rgba(c3dde7ee)
    '';
  };
}
