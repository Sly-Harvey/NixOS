{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h bluetoothSupport;
in
{
  # Optional Dependencies
  # https://hyprpanel.com/getting_started/astal.html#dependencies
  environment.systemPackages = with pkgs; [
    wl-clipboard
    python314Packages.gpustat
    brightnessctl
    wf-recorder
  ];
  home-manager.sharedModules = [
    (_: {
      programs.hyprpanel = {
        enable = true;
        systemd.enable = false;
        settings = {
          tear = true;
          notifications = {
            timeout = 3500;
            autoDismiss = true;
            ignore = [ ]; # Class name
          };
          theme = {
            font.size = "1.1rem";
            bar = {
              floating = false;
              transparent = false;
              border.location = "none";
              border_radius = "1em";
              outer_spacing = "0.6em";
              buttons = {
                style = "default"; # wave, wave2, default
                workspaces.pill.height = "4em";
                workspaces.pill.width = "4em";
                workspaces.pill.active_width = "9em";
              };
            };

            # Opacities
            /*
              bar.buttons.opacity = 100;
              bar.buttons.background_hover_opacity = 100;
              bar.opacity = 80;
              bar.menus.opacity = 80;
              bar.buttons.background_opacity = 80;
              notification.opacity = 80;
            */
          };
          bar = {
            autoHide = "fullscreen"; # fullscreen, never
            systray.ignore = [ ]; # Binary name (e.g. "nm-applet")
            launcher = {
              rightClick = "launcher drun";
              autoDetectIcon = true;
            };
            windowtitle.title_map = [
              [
                "gjs"
                ""
                "Hyprpanel Settings"
              ]
            ];
            network = {
              label = true;
              showWifiInfo = true;
              truncation = true;
            };
            bluetooth.rightClick = "blueman-manager";
            volume.rightClick = "pavucontrol";
            media = {
              format = "{title}";
              show_active_only = true;
              # format = "{artist: - }{title}";
              rightClick = "${pkgs.playerctl}/bin/playerctl play-pause";
              truncation_size = 25; # Default: 30
            };
            clock = {
              showIcon = false;
              showTime = true;
              format = "%a %d %b  %R";
            };
            workspaces = {
              workspaces = 10;
              ignored = "-99"; # -99 is special workspace
              monitorSpecific = false;
              showAllActive = false;
              show_icons = false;
              icons.available = "";
              show_numbered = false;
              workspaceMask = false;
              showWsIcons = false;
              icons.occupied = "";
            };
            enableShadow = false;
            layouts = {
              "*" = {
                left = [
                  "dashboard"
                  "workspaces"
                  "cava"
                ];
                middle = [
                  "windowtitle"
                  # "media"
                ];
                right =
                  [ ]
                  ++ lib.optionals (bluetoothSupport == true) [
                    "volume"
                    "network"
                    "bluetooth"
                    "battery"
                    "systray"
                    "hypridle"
                    "clock"
                    "notifications"
                  ]
                  ++ lib.optionals (bluetoothSupport != true) [
                    "volume"
                    "network"
                    "battery"
                    "systray"
                    "hypridle"
                    "clock"
                    "notifications"
                  ];
              };
            };
            customModules = {
              cava.leftClick = "${pkgs.playerctl}/bin/playerctl play-pause";
              hyprsunset.temperature = "4000k";
              hypridle = {
                onIcon = "󰥔";
                offIcon = "";

                label = false;
                onLabel = "On";
                offLabel = "Off";
              };
            };
          };
          menus = {
            media = {
              hideAuthor = false;
              hideAlbum = false;
            };
            clock = {
              time = {
                military = clock24h;
                hideSeconds = true;
              };
              weather = {
                enabled = false;
                unit = "metric";
                location = "London";
              };
            };
            dashboard = {
              powermenu.avatar.image = "${./profile-picture.jpg}";
              recording.path = "$HOME/Videos/screen-record";
              directories.enabled = false;
              stats.enable_gpu = true;
              shortcuts = {
                left = {
                  shortcut1.tooltip = "Zen Browser";
                  shortcut1.command = "zen-beta";
                  shortcut1.icon = "";
                  shortcut2.command = "spotify";
                  shortcut4.command = "launcher drun";
                };
              };
            };
          };
        };
      };
    })
  ];
}
