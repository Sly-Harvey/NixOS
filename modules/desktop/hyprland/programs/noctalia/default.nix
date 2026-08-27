{
  inputs,
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) timezone clock24h bluetoothSupport;
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
              "weather"
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
              enabled = false;
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
            address = timezone;
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
            widget =
              let
                forDisplays =
                  displays: conf:
                  builtins.listToAttrs (
                    lib.flatten (
                      map (
                        w:
                        (map (d: {
                          name = "${w.name}@${d}";
                          value = w.value // {
                            output = d;
                          };
                        }) displays)
                      ) (lib.attrsToList conf)
                    )
                  );
              in
              let
                displays =
                  (map (n: "DP-${toString n}") (lib.range 1 4))
                  ++ (map (n: "eDP-${toString n}") (lib.range 1 4))
                  ++ (map (n: "HDMI-A-${toString n}") (lib.range 1 4))
                  ++ (map (n: "DVI-D-${toString n}") (lib.range 1 4))
                  ++ (map (n: "DVI-I-${toString n}") (lib.range 1 4))
                  ++ (map (n: "VGA-${toString n}") (lib.range 1 4));
              in
              forDisplays displays {
                lockscreen-login-box = {
                  enabled = true;
                  box_height = 196.0;
                  box_width = 810.0;
                  cx = 960.0;
                  cy = 898.0;
                  placement_height = 1080.0;
                  placement_width = 1920.0;
                  rotation = 0.0;
                  type = "login_box";
                  settings = {
                    background_color = "surface_variant";
                    background_opacity = 0.88;
                    background_radius = 12.0;
                    center_password_text = false;
                    input_opacity = 1.0;
                    input_radius = 6.0;
                    layout = "regular";
                    show_caps_lock = true;
                    show_keyboard_layout = true;
                    show_login_button = true;
                    show_media = true;
                    show_session_buttons = false;
                    show_unlock_hint = true;
                    show_weather = true;
                  };
                };
                lockscreen-widget-fancy-audio-visualizer = {
                  enabled = true;
                  box_height = 0.0;
                  box_width = 0.0;
                  cx = 960.0;
                  cy = 540.0;
                  placement_height = 1080.0;
                  placement_width = 1920.0;
                  rotation = 0.0;
                  type = "fancy_audio_visualizer";
                  settings = {
                    background = false;
                    background_color = "surface";
                    background_opacity = 0.80000000000000004;
                    background_padding = 10;
                    background_radius = 12;
                    bar_width = 0.59999999999999998;
                    bloom_intensity = 0.5;
                    fade_when_idle = true;
                    inner_diameter = 0.69999999999999996;
                    primary_color = "primary";
                    ring_opacity = 0.80000000000000004;
                    rotation_speed = 0.5;
                    secondary_color = "secondary";
                    sensitivity = 1.5;
                    visualization_mode = "bars_rings";
                    wave_thickness = 1.0;
                  };
                };
                lockscreen-widget-clock = {
                  box_height = 80.0;
                  box_width = 448.0;
                  cx = 960.0;
                  cy = 196.0;
                  enabled = false;
                  placement_height = 1080.0;
                  placement_width = 1920.0;
                  rotation = 0.0;
                  type = "clock";
                  settings = {
                    background = false;
                    clock_style = "digital";
                    color = "secondary";
                    font_family = "";
                    format = "{:%a %d %b %R}";
                    shadow = false;
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
            mpris.blacklist = [ "firefox" ];
          };
          theme = {
            builtin = "Catppuccin";
            community_palette = "Catppuccin Macchiato Mauve";
            mode = "dark";
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
            keyboard_layout.enabled = false;
            launcher.enabled = false;
            media = {
              art_size = 32;
              capsule_padding = 8;
              hide_when_no_media = true;
            };
            network.show_label = false;
            ram = {
              stat = "ram_used";
              type = "sysmon";
              visualization = "none";
            };
            cpu = {
              stat = "cpu_usage";
              type = "sysmon";
              visualization = "none";
            };
            temp = {
              stat = "gpu_temp";
              type = "sysmon";
              visualization = "none";
            };
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
            tray = {
              drawer = true;
              hide_passive = false;
            };
            wallpaper.enabled = false;
            weather = {
              enabled = true;
              effects = true;
              refresh_minutes = 30;
              unit = "metric";
            };
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
