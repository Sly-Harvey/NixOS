{ host, pkgs, ... }:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h terminal;

in
{
  home-manager.sharedModules = [
    (_: {
      programs.waybar = {
        enable = true;
        settings = [
          {
            layer = "top";
            position = "top";
            mode = "dock";
            height = 0;
            spacing = 0;
            exclusive = true;
            passthrough = false;
            gtk-layer-shell = true;
            reload_style_on_change = true;
            ipc = true;
            fixed-center = true;
            margin-top = 0;
            margin-left = 0;
            margin-right = 0;
            margin-bottom = 0;

            modules-left = [
              "group/user"
              "custom/left_div-1"
              "hyprland/workspaces"
              "custom/right_div-1"
              "hyprland/window"
            ];
            modules-center = [
              "hyprland/windowcount"
              "custom/left_div-2"
              "custom/gpuinfo"
              "custom/left_div-3"
              "memory"
              "custom/left_div-4"
              "cpu"
              "custom/left_inv-1"
              "custom/left_div-5"
              "custom/distro"
              "custom/right_div-2"
              "custom/right_inv-1"
              "idle_inhibitor"
              "clock#time"
              "custom/right_div-3"
              "clock#date"
              "custom/right_div-4"
              "network"
              "bluetooth"
              "custom/system_update"
              "custom/right_div-5"
            ];
            modules-right = [
              "mpris"
              "custom/left_div-6"
              "group/pulseaudio"
              "custom/left_div-7"
              "backlight"
              "custom/left_div-8"
              "battery"
              "custom/left_inv-2"
              "custom/notification"
              "custom/power_menu"
            ];

            "group/user" = {
              orientation = "horizontal";
              modules = [
                "custom/trigger"
                # "custom/user"
                "tray"
                # "wlr/taskbar"
              ];
              drawer = { };
            };
            "custom/trigger" = {
              format = "󰍜";
              min-length = 4;
              max-length = 4;
              tooltip = false;
            };
            "custom/user" = {
              exec = "id -un";
              format = "{}";
              tooltip = false;
            };
            "wlr/taskbar" = {
              on-click = "activate";
              ignore-list = [ "kitty" ];
              cursor = true;
            };

            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                active = "";
                default = "";
              };
              persistent-workspaces = {
                "*" = [
                  1
                  2
                  3
                  4
                  5
                  6
                  7
                  8
                  9
                  10
                ];
              };
              on-scroll-up = "hyprctl dispatch workspace +1";
              on-scroll-down = "hyprctl dispatch workspace -1";
              cursor = true;
            };

            "hyprland/window" = {
              format = "{}";
              rewrite = {
                "" = "Desktop";
                "kitty" = "Terminal";
                "zsh" = "Terminal";
                "~" = "Terminal";
              };
              swap-icon-label = false;
              icon = true;
            };

            "hyprland/windowcount" = {
              format = "[{}]";
              swap-icon-label = false;
            };

            "temperature" = {
              hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
              critical-threshold = 90;
              format-critical = "󰀦 {temperatureC}°C";
              format = "{icon} {temperatureC}°C";
              format-icons = [
                "󱃃"
                "󰔏"
                "󱃂"
              ];
              interval = 10;
            };
            "memory" = {
              interval = 10;
              format = "󰘚 {percentage}%";
              format-warning = "󰀧 {percentage}%";
              format-critical = "󰀧 {percentage}%";
              states = {
                warning = 75;
                critical = 90;
              };
              min-length = 7;
              max-length = 7;
              tooltip-format = "Memory Used: {used:0.1f} GB / {total:0.1f} GB";
            };
            "cpu" = {
              interval = 10;
              format = "󰍛 {usage}%";
              format-warning = "󰀨 {usage}%";
              format-critical = "󰀨 {usage}%";
              min-length = 7;
              max-length = 7;
              states = {
                warning = 75;
                critical = 90;
              };
              tooltip = false;
            };

            "custom/distro" = {
              format = "";
              tooltip = true;
              tooltip-format = "I use NixOS, btw.";
            };

            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "󰈈";
                deactivated = "󰈉";
              };
              min-length = 3;
              max-length = 3;
              tooltip-format-activated = "Keep Screen On: <span text_transform='capitalize'>{status}</span>";
              tooltip-format-deactivated = "Keep Screen On: <span text_transform='capitalize'>{status}</span>";
              start-activated = false;
            };

            "clock#time" = {
              format = if clock24h == true then "{:%R}" else "{:%I:%M}";
              format-alt = if clock24h == true then "{:%I:%M}" else "{:%R}";
              min-length = 5;
              max-length = 5;
              tooltip-format = "Standard Time: {:%I:%M %p}";
            };
            "clock#date" = {
              format = "󰸗 {:%m-%d}";
              min-length = 7;
              max-length = 7;
              tooltip-format = "{calendar}";
              calendar = {
                mode = "month";
                mode-mon-col = 6;
                format = {
                  months = "<span alpha='100%'><b>{}</b></span>";
                  days = "<span alpha='90%'>{}</span>";
                  weekdays = "<span alpha='80%'><i>{}</i></span>";
                  today = "<span alpha='100%'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click = "mode";
              };
            };

            "network" = {
              interval = 10;
              format = "󰤨";
              format-ethernet = "󰈀";
              format-wifi = "{icon}";
              format-disconnected = "󰤯";
              format-disabled = "󰤮";
              format-icons = [
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
              min-length = 2;
              max-length = 2;
              on-click = "nm-connection-editor";
              tooltip-format = "Gateway: {gwaddr}";
              tooltip-format-ethernet = "Interface: {ifname}";
              tooltip-format-wifi = "Network: {essid}\nIP Addr: {ipaddr}/{cidr}\nStrength: {signalStrength}%\nFrequency: {frequency} GHz";
              tooltip-format-disconnected = "Wi-Fi Disconnected";
              tooltip-format-disabled = "Wi-Fi Disabled";
            };
            "bluetooth" = {
              format = "󰂯";
              format-disabled = "󰂲";
              format-off = "󰂲";
              format-on = "󰂰";
              format-connected = "󰂱";
              min-length = 2;
              max-length = 2;
              on-click = "blueman-manager";
              on-click-right = "bluetoothctl power off && notify-send 'Bluetooth Off' -i 'network-bluetooth-inactive' -r 1925";
              tooltip-format = "Device Addr: {device_address}";
              tooltip-format-disabled = "Bluetooth Disabled";
              tooltip-format-off = "Bluetooth Off";
              tooltip-format-on = "Bluetooth Disconnected";
              tooltip-format-connected = "Device: {device_alias}";
              tooltip-format-enumerate-connected = "Device: {device_alias}";
              tooltip-format-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
              tooltip-format-enumerate-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
            };

            "custom/system_update" = {
              format = "";
              on-click = "${terminal} -e rebuild";
              min-length = 1;
              max-length = 1;
              tooltip = false;
            };

            "mpris" = {
              format = "{player_icon} {title} - {artist}";
              format-paused = "{status_icon} {title} - {artist}";
              tooltip-format = "Playing: {title} - {artist}";
              tooltip-format-paused = "Paused: {title} - {artist}";
              player-icons = {
                default = "󰐊";
              };
              status-icons = {
                paused = "󰏤";
              };
              max-length = 1000;
            };

            "group/pulseaudio" = {
              orientation = "horizontal";
              modules = [
                "pulseaudio#output"
                "pulseaudio#input"
                # "tray"
              ];
              drawer = {
                # "transition-duration":
                transition-left-to-right = false;
                # "children-class":
                # "click-to-reveal":
              };
            };

            "pulseaudio#output" = {
              format = "{icon} {volume}%";
              # "format-bluetooth":
              format-muted = "{icon} {volume}%";
              # "format-source":
              # "format-source-muted":
              format-icons = {
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
                default-muted = "󰝟";
                headphone = "󰋋";
                headphone-muted = "󰟎";
                headset = "󰋎";
                headset-muted = "󰋐";
              };
              min-length = 7;
              max-length = 7;
              on-click = "pavucontrol -t 3";
              tooltip-format = "Output Device: {desc}";
            };

            "pulseaudio#input" = {
              format = "{format_source}";
              format-source = "󰍬 {volume}%";
              format-source-muted = "󰍭 {volume}%";
              min-length = 7;
              max-length = 7;
              scroll-step = 1;
              on-click = "pavucontrol -t 4";
              # on-click = "pamixer --default-source --toggle-mute";
              tooltip-format = "Input Device: {desc}";
            };

            "group/wireplumber" = {
              orientation = "horizontal";
              modules = [
                "wireplumber#output"
                "wireplumber#input"
                "tray"
              ];
              drawer = {
                transition-left-to-right = false;
              };
            };
            "wireplumber#output" = {
              format = "{icon} {volume}%";
              format-muted = "{icon} {volume}%";
              format-icons = {
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
                default-muted = "󰝟";
                headphone = "󰋋";
                headphone-muted = "󰟎";
                headset = "󰋎";
                headset-muted = "󰋐";
              };
              on-click = "pavucontrol -t 3";
              on-scroll-up = "wpctl set-volume @DEFAULT_SINK@ 1%+";
              on-scroll-down = "wpctl set-volume @DEFAULT_SINK@ 1%-";
              tooltip-format = "{icon} {node_name} // {volume}%";
              min-length = 7;
              max-length = 7;
              scroll-step = 1;
              node-type = "Audio/Sink";
            };
            "wireplumber#input" = {
              format = "{icon} {volume}%";
              format-muted = "";
              format-icons = {
                default = "";
              };
              min-length = 7;
              max-length = 7;
              scroll-step = 1;
              on-click = "pamixer --default-source --toggle-mute";
              node-type = "Audio/Source";
            };
            "tray" = {
              icon-size = 16;
              spacing = 12;
              cursor = true;
            };

            "backlight" = {
              format = "{icon} {percent}%";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
              min-length = 7;
              max-length = 7;
              on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+";
              on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
              tooltip = false;
            };

            "battery" = {
              states = {
                warning = 20;
                critical = 10;
              };
              format = "{icon} {capacity}%";
              format-time = "{H} hr {M} min";
              format-icons = [
                "󰂎"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              format-charging = "󰉁 {capacity}%";
              min-length = 7;
              max-length = 7;
              tooltip-format = "Discharging: {time}";
              tooltip-format-charging = "Charging: {time}";
              events = {
                on-discharging-warning = "notify-send 'Battery Low (20%)' -i 'battery-020'";
                on-discharging-critical = "notify-send 'Battery Critical (10%)' -u critical -i 'battery-010'";
                on-charging-100 = "notify-send 'Battery Full (100%)' -i 'battery-100-charged'";
              };
            };

            "custom/notification" = {
              tooltip = false;
              format = "{icon}";
              format-icons = {
                notification = "<span foreground='red'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='red'><sup></sup></span>";
                dnd-none = "";
                inhibited-notification = "<span foreground='red'><sup></sup></span>";
                inhibited-none = "";
                dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
                dnd-inhibited-none = "";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };

            "custom/power_menu" = {
              format = "";
              on-click = "pkill -x wlogout || wlogout -b 4";
              tooltip-format = "Power Menu";
            };

            "custom/left_div-1" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div-2" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div-3" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div-4" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div-5" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div-6" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div-7" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div-8" = {
              format = "";
              tooltip = false;
            };
            "custom/left_inv-1" = {
              format = "";
              tooltip = false;
            };
            "custom/left_inv-2" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div-1" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div-2" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div-3" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div-4" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div-5" = {
              format = "";
              tooltip = false;
            };
            "custom/right_inv-1" = {
              format = "";
              tooltip = false;
            };

            "custom/gpuinfo" = {
              min-length = 7;
              max-length = 7;
              exec = "${../../scripts/gpuinfo.sh}";
              return-type = "json";
              format = "{0}";
              on-click = "${../../scripts/gpuinfo.sh} --toggle";
              interval = 10;
              tooltip = true;
            };
          }
        ];
        style = ''
          * {
              font-family: "0xProto Nerd Font";
              font-weight: bold;
              font-size: 16px;
              color: @main-fg;
          }

          #waybar {
              background-color: @main-bg;
          }

          #waybar > box {
              margin: 4px;
              background-color: @main-bg;
          }

          tooltip {
              border: 2px solid @main-br;
              border-radius: 10px;
              background-color: @main-bg;
          }
          tooltip > box {
              padding: 0 6px;
          }

          #custom-user,
          #window label,
          #mpris,
          tooltip label {
              font-weight: normal;
          }

          #workspaces button.active label,
          #custom-distro {
              font-size: 23px;
          }

          #custom-power_menu {
              font-size: 20px;
          }

          #custom-left_div-1, #custom-left_div-2, #custom-left_div-3, #custom-left_div-4,
          #custom-left_div-5, #custom-left_div-6, #custom-left_div-7, #custom-left_div-8,
          #custom-right_div-1, #custom-right_div-2, #custom-right_div-3, #custom-right_div-4,
          #custom-right_div-5,
          #custom-left_inv-1, #custom-left_inv-2,
          #custom-right_inv-1 {
              font-size: 23.1px;
          }

          #custom-user {
              padding-right: 12px;
          }

          #custom-left_div-1,
          #custom-right_div-1 {
              color: @workspaces;
          }
          #workspaces {
              padding: 0 1px;
              background-color: @workspaces;
          }
          #workspaces button {
              border-radius: 16px;
              min-width: 16px;
              padding: 0 5px;
          }
          #workspaces button:hover {
              background-color: @hover-bg;
              color: @hover-fg;
          }
          #workspaces button.active label {
              color: @accent;
          }

          #window {
              margin-left: 12px;
          }

          #windowcount {
              margin-right: 12px;
          }
          #windowcount label {
              color: @hover-fg;
          }

          #custom-left_div-2 {
              color: @temperature;
          }
          #temperature {
              background-color: @temperature;
          }
          #custom-gpuinfo {
              background-color: @temperature;
          }

          #custom-left_div-3 {
              background-color: @temperature;
              color: @memory;
          }
          #memory {
              background-color: @memory;
          }

          #custom-left_div-4 {
              background-color: @memory;
              color: @cpu;
          }
          #cpu {
              background-color: @cpu;
          }
          #custom-left_inv-1 {
              color: @cpu;
          }

          #custom-left_div-5,
          #custom-right_div-2 {
              color: @accent;
          }
          #custom-distro {
              padding: 0 12px 0 4px;
              background-color: @accent;
              color: @main-bg;
          }

          #custom-right_inv-1 {
              color: @time;
          }
          #idle_inhibitor {
              background-color: @time;
          }

          #clock.time {
              padding-right: 6px;
              background-color: @time;
          }
          #custom-right_div-3 {
              background-color: @date;
              color: @time;
          }

          #clock.date {
              padding-left: 6px;
              background-color: @date;
          }
          #custom-right_div-4 {
              background-color: @tray;
              color: @date;
          }

          #network, #bluetooth, #custom-system_update {
              background-color: @tray;
          }
          #network {
            padding: 0 6px 0 4px;
          }
          #bluetooth {
            padding: 0 5px;
          }
          #custom-system_update {
            padding: 0 8px 0 2px;
          }
          #custom-right_div-5 {
              color: @tray;
          }

          #mpris {
              padding: 0 12px;
          }

          #custom-left_div-6 {
              color: @volume;
          }

          #pulseaudio,
          #wireplumber {
              background-color: @volume;
          }

          #custom-left_div-7 {
              background-color: @volume;
              color: @backlight;
          }
          #backlight {
              background-color: @backlight;
          }

          #custom-left_div-8 {
              background-color: @backlight;
              color: @battery;
          }
          #battery {
              background-color: @battery;
          }
          #custom-left_inv-2 {
              color: @battery;
          }

          #custom-notification {
              padding: 0 10px;
          }

          #custom-power_menu {
              border-radius: 16px;
              padding: 0 19px 0 16px;
              color: @accent;
          }
          #custom-power_menu:hover {
              background-color: @hover-bg;
          }

          #custom-trigger:hover,
          #idle_inhibitor:hover,
          #clock.date:hover,
          #network:hover,
          #bluetooth:hover,
          #custom-system_update:hover,
          #mpris:hover,
          #wireplumber:hover {
              color: @hover-fg;
          }

          #idle_inhibitor.deactivated,
          #mpris.paused,
          #wireplumber.muted {
              color: @hover-fg;
          }

          #memory.warning,
          #cpu.warning,
          #battery.warning {
              color: @warning;
          }

          #temperature.critical,
          #memory.critical,
          #cpu.critical,
          #battery.critical {
              color: @critical;
          }

          #battery.charging {
              color: @charging;
          }

          @define-color rosewater		#f5e0dc;
          @define-color flamingo		#f2cdcd;
          @define-color pink			#f5c2e7;
          @define-color mauve			#cba6f7;
          @define-color red			#f38ba8;
          @define-color maroon		#eba0ac;
          @define-color peach			#fab387;
          @define-color yellow		#f9e2af;
          @define-color green			#a6e3a1;
          @define-color teal			#94e2d5;
          @define-color sky			#89dceb;
          @define-color sapphire		#74c7ec;
          @define-color blue			#89b4fa;
          @define-color lavender		#b4befe;
          @define-color text			#cdd6f4;
          @define-color subtext1		#bac2de;
          @define-color subtext0		#a6adc8;
          @define-color overlay2		#9399b2;
          @define-color overlay1		#7f849c;
          @define-color overlay0		#6c7086;
          @define-color surface2		#585b70;
          @define-color surface1		#45475a;
          @define-color surface0		#313244;
          @define-color base			#1e1e2e;
          @define-color mantle		#181825;
          @define-color crust			#11111b;

          @define-color accent		@lavender;
          @define-color main-br		@subtext0;
          @define-color main-bg		@crust;
          @define-color main-fg		@text;
          @define-color hover-bg		@base;
          @define-color hover-fg		alpha(@main-fg, 0.75);
          @define-color outline		shade(@main-bg, 0.5);

          @define-color workspaces	@mantle;
          @define-color temperature	@mantle;
          @define-color memory		@base;
          @define-color cpu			@surface0;
          @define-color time			@surface0;
          @define-color date			@base;
          @define-color tray			@mantle;
          @define-color volume		@mantle;
          @define-color backlight		@base;
          @define-color battery		@surface0;

          @define-color warning		@yellow;
          @define-color critical		@red;
          @define-color charging		@green;
        '';
      };
    })
  ];
}
