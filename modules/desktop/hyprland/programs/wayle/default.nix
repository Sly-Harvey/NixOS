{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h bluetoothSupport batterySupport;
in
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    python314Packages.gpustat
    brightnessctl
    wf-recorder
  ];

  # Wayle reads avatar from ~/.face
  environment.etc."wayle-face".source = ./profile-picture.jpg;

  home-manager.sharedModules = [
    (_: {
      services.wayle = {
        enable = true;
        settings = {
          # ── Acid-HUD Palette ──────────────────────────────────────
          styling = {
            theme-provider = "wayle";
            rounding = "sm";
            palette = {
              bg = "#241f2b";
              surface = "#312d3d";
              elevated = "#312d3d";
              fg = "#e0dce4";
              fg-muted = "#a8988f";
              primary = "#a11bae";
              red = "#fa1d42";
              yellow = "#eeeb5f";
              green = "#d9ff3b";
              blue = "#0091cb";
            };
          };

          # ── Bar Chrome ────────────────────────────────────────────
          bar = {
            location = "top";
            background-opacity = 100;
            rounding = "sm";
            border-location = "none";
            padding = 0.35;
            padding-ends = 0.5;
            module-gap = 0.5;
            button-variant = "block-prefix";
            button-rounding = "sm";
            button-label-weight = "semibold";
            layout = [
              {
                monitor = "*";
                left = [
                  "dashboard"
                  "hyprland-workspaces"
                  "cava"
                ];
                center = [
                  "window-title"
                ];
                right =
                  [ "volume" "network" "systray" "idle-inhibit" "clock" "notifications" ]
                  ++ lib.optionals (bluetoothSupport == true) [ "bluetooth" ]
                  ++ lib.optionals (batterySupport == true) [ "battery" ];
              }
            ];
          };

          # ── Module Settings ──────────────────────────────────────
          modules = {
            # Dashboard (profile dropdown with power menu)
            dashboard = {
              icon-override = "";
            };

            # Workspaces (10 workspaces, non-monitor-specific, no icons/numbers)
            hyprland-workspaces = {
              min-workspace-count = 10;
              monitor-specific = false;
              show-special = false;
              display-mode = "label";
              label-use-name = false;
              numbering = "absolute";
              app-icons-show = false;
              workspace-ignore = [ "-99" ];
              active-indicator = "background";
            };

            # Cava (audio visualizer, click = play/pause)
            cava = {
              bars = 20;
              framerate = 60;
              style = "bars";
              direction = "normal";
              left-click = "${pkgs.playerctl}/bin/playerctl play-pause";
            };

            # Window title
            window-title = {
              icon-show = true;
              label-show = true;
              label-max-length = 50;
            };

            # Volume
            volume = {
              right-click = "pavucontrol";
            };

            # Network (show label + wifi info)
            network = {
              label-show = true;
            };

            # System tray
            systray = {};

            # Idle inhibit (hypridle toggle)
            idle-inhibit = {
              format = "{{ state }}";
              icon-active = "tb-coffee-symbolic";
              icon-inactive = "tb-coffee-off-symbolic";
              label-show = true;
              startup-duration = 60;
            };

            # Clock (24h format matching hyprpanel)
            clock = {
              format = "%a %d %b  %R";
              icon-show = false;
              label-show = true;
            };

            # Notifications (built-in, replaces swaync)
            notifications = {
              popup-duration = 3500;
              popup-position = "top-right";
              popup-max-visible = 5;
            };

            # Media (title only, truncated to 25 chars)
            media = {
              format = "{{ title }}";
              label-max-length = 25;
            };
          };
        };
      };

      # Symlink profile picture to ~/.face for Wayle dashboard avatar
      xdg.configFile."wayle-avatar" = {
        source = ./profile-picture.jpg;
        target = "../.face";
      };
    })
  ];
}
