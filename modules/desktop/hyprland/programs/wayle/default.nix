{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix)
    clock24h
    bluetoothSupport
    batterySupport
    ;
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
      # home.shellAliases = {
      #   wayle-shell = "wayle shell";
      # };
      services.wayle = {
        enable = true;
        settings = {
          # ── Acid-HUD Palette ──────────────────────────────────────
          styling = {
            theme-provider = "wayle";
            rounding = "sm";
            palette = {
              bg = "#11111b";
              surface = "#181825";
              elevated = "#1e1e2e";
              fg = "#cdd6f4";
              fg-muted = "#bac2de";
              primary = "#b4befe";
              red = "#f38ba8";
              yellow = "#f9e2af";
              green = "#a6e3a1";
              blue = "#74c7ec";
            };
          };

          # ── Bar Chrome ────────────────────────────────────────────
          bar = {
            location = "top";
            background-opacity = 100;
            rounding = "no";
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
                right = [
                  "volume"
                  "network"
                  "systray"
                  "idle-inhibit"
                  "clock"
                  "notifications"
                ]
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
            systray = { };

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
              # format = "%a %d %b  %R";
              format = if clock24h == true then "%a %d %b %R" else "%a %d %b %I:%M %p";
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
