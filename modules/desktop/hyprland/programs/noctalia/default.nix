{
  inputs,
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
  environment.systemPackages = with pkgs; [
    wl-clipboard
    brightnessctl
  ];
  home-manager.sharedModules = [
    (_: {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      services.hypridle.enable = lib.mkForce false;
      programs.hyprlock.enable = lib.mkForce false;
      programs.wlogout.enable = lib.mkForce false;
      programs.noctalia = {
        enable = true;
        systemd.enable = false;
        settings = {
          bar.default = {
            enabled = true;
            auto_hide = false;
            background_opacity = 1.0;
            thickness = 38;
            border = "outline";
            border_width = 0.5;
            font_weight = 500;
            reserve_space = true;
            layer = "top";
            position = "top";
            margin_edge = 10;
            margin_ends = 10;
            margin_opposite_edge = 0;
            padding = 14;
            widget_spacing = 6;
            radius = 12;
            scale = 1.0;
            shadow = false;
            show_on_workspace_switch = true;
            start = [
              "control-center"
              "workspaces"
              "audio_visualizer"
              "media"
            ];
            center = [
              "caffeine"
              "clock"
            ];
            end = [
              "group:g1"
              "tray"
              "keyboard_layout"
              "clipboard"
              "network"
              "bluetooth"
              "volume"
              "brightness"
              "notifications"
              "battery"
              "session"
            ];
            dead_zone.actions = {
              back = "exec noctalia msg panel-toggle yuuto/calculator:panel";
            };
            capsule_group = {
              accordion = false;
              accordion_direction = "end";
              enabled = true;
              fill = "surface_variant";
              id = "g1";
              members = [
                "temp"
                "cpu"
                "ram"
              ];
              opacity = 1.0;
              padding = 8.0;
            };
          };
          control_center = {
            sidebar = "full";
            shortcuts = [
              {
                type = "wifi";
              }
              {
                type = "bluetooth";
              }
              {
                type = "caffeine";
              }
              {
                type = "nightlight";
              }
              {
                type = "notification";
              }
              {
                type = "session";
              }
            ];
          };
          desktop_widgets = {
            enabled = false;
            widget_order = [
              "desktop-widget-0000000000000001"
              "desktop-widget-0000000000000002"
            ];
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
            widget = {
              desktop-widget-0000000000000001 = {
                box_height = 160.0;
                box_width = 1920.0;
                cx = 960.0;
                cy = 988.0;
                output = "DP-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "audio_visualizer";
                settings = {
                  background = false;
                  bands = 72;
                  centered = false;
                  color_2 = "primary";
                  show_when_idle = false;
                };
              };
              desktop-widget-0000000000000002 = {
                box_height = 0.0;
                box_width = 0.0;
                cx = 960.0;
                cy = 540.0;
                output = "DP-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "fancy_audio_visualizer";
                settings = {
                  background = false;
                };
              };
            };
          };
          dock.size = 34;
          idle = {
            behavior_order = [
              "lock"
              "screen-off"
              "lock-and-suspend"
            ];
            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 600.0;
              };
              lock-and-suspend = {
                action = "lock-and-suspend";
                enabled = true;
                timeout = 900.0;
              };
              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 660.0;
              };
            };
          };
          location = {
            address = "London, United Kingdom";
            auto_locate = false;
          };
          lockscreen = {
            allow_empty_password = false;
            blur_intensity = 0.5;
            blurred_desktop = false;
            enabled = true;
            fingerprint = true;
            lock_before_suspend = true;
            monitors = [ ];
            tint_intensity = 0.30000001192092896;
            wallpaper = "${../../../../themes/wallpapers/quasar.webp}";
          };
          lockscreen_widgets = {
            enabled = true;
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
            widget = {
              lockscreen-widget-0000000000000001 = {
                box_height = 0.0;
                box_width = 0.0;
                cx = 960.0;
                cy = 540.0;
                placement_height = 1080.0;
                placement_width = 1920.0;
                enabled = true;
                rotation = 0.0;
                type = "fancy_audio_visualizer";
                settings = {
                  background = false;
                };
              };
            };
          };
          notification = {
            filter_order = [ ];
            history_retention_hours = 72;
          };
          plugins = {
            enabled = [ "yuuto/calculator" ];
          };
          shell = {
            avatar_path = "${./profile-picture.jpg}";
            screenshot.directory = "~/Pictures/Screenshots";
            setup_wizard_enabled = false;
            clipboard_enabled = true;
            mpris.blacklist = [];
          };
          theme = {
            builtin = "Catppuccin";
            community_palette = "Catppuccin Macchiato Mauve";
            mode = "auto";
            source = "community";
            templates = {
              enable_builtin_templates = false;
              enable_community_templates = false;
            };
          };
          wallpaper = {
            enabled = false;
            directory = "${../../../../themes/wallpapers}";
            directory_dark = "${../../../../themes/wallpapers}";
            directory_light = "${../../../../themes/wallpapers}";
            transition = [
              "disc"
              "fade"
              "honeycomb"
              "wipe"
              "zoom"
            ];
          };
          widget = {
            audio_visualizer = {
              bands = 15;
              centered = false;
              enabled = false;
              mirrored = false;
              scale = 1.1000000000000001;
              show_when_idle = true;
              width = 76;
            };
            caffeine.scale = 1.1500000000000001;
            clipboard.enabled = false;
            clock = {
              anchor = true;
              color = "secondary";
              format = "{:%a %d %b %R}";
            };
            control-center = {
              glyph = "lambda";
              icon_color = "tertiary";
              scale = 1.5;
            };
            cpu.visualization = "none";
            keyboard_layout.enabled = false;
            launcher.enabled = false;
            media = {
              art_size = 32;
              capsule_padding = 8;
              hide_when_no_media = true;
            };
            network.show_label = false;
            ram.visualization = "none";
            session = {
              icon_color = "#ED8796";
              scale = 1.5;
              actions.right = "exec wlogout -b 4";
            };
            sysmon = {
              enabled = false;
              glyph = "cpu";
              visualization = "none";
            };
            temp = {
              stat = "gpu_temp";
              visualization = "none";
            };
            tray = {
              drawer = true;
              hide_passive = false;
            };
            wallpaper.enabled = false;
            workspaces = {
              capsule = true;
              style = "minimal";
            };
          };
        };
      };
    })
  ];
}
