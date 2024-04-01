{
  username,
  ...
}: {
  home-manager.users.${username} = _: {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
                        * {
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        min-height: 0;
        /* set font-size to 100% if font scaling is set to 1.00 using nwg-look */
        font-size: 97%;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        padding: 1px;
        }

        @define-color base   #1e1e2e;
        @define-color mantle #181825;
        @define-color crust  #11111b;

        @define-color text     #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;

        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;

        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;

        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;

        window#waybar {
          transition-property: background-color;
          transition-duration: 0.5s;
          background: transparent;
          /*border: 2px solid @overlay0;*/
          /*background: @theme_base_color;*/
          border-radius: 10px;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        #waybar.empty #window {
          background: none;
        }

        /* This section can be use if you want to separate waybar modules */
        .modules-left, .modules-center, .modules-right {
        	background: @theme_base_color;
         	border: 0.5px solid @overlay0;
        	padding-top: 2px;
        	padding-bottom: 2px;
        	padding-right: 4px;
        	padding-left: 4px;
        	border-radius: 10px;

        }

        .modules-left, .modules-right {
          	border: 1px solid @blue;
        	padding-top: 2px;
        	padding-bottom: 2px;
        	padding-right: 4px;
        	padding-left: 4px;
        }

        #backlight,
        #backlight-slider,
        #battery,
        #bluetooth,
        #clock,
        #cpu,
        #disk,
        #idle_inhibitor,
        #keyboard-state,
        #memory,
        #mode,
        #mpris,
        #network,
        #pulseaudio,
        #pulseaudio-slider,
        #taskbar button,
        #taskbar,
        #temperature,
        #tray,
        #window,
        #wireplumber,
        #workspaces,
        #custom-backlight,
        #custom-cycle_wall,
        #custom-keybinds,
        #custom-keyboard,
        #custom-light_dark,
        #custom-lock,
        #custom-menu,
        #custom-power_vertical,
        #custom-power,
        #custom-swaync,
        #custom-updater,
        #custom-weather,
        #custom-weather.clearNight,
        #custom-weather.cloudyFoggyDay,
        #custom-weather.cloudyFoggyNight,
        #custom-weather.default,
        #custom-weather.rainyDay,
        #custom-weather.rainyNight,
        #custom-weather.severe,
        #custom-weather.showyIcyDay,
        #custom-weather.snowyIcyNight,
        #custom-weather.sunnyDay {
        	padding-top: 3px;
        	padding-bottom: 3px;
        	padding-right: 6px;
        	padding-left: 6px;
        }

        #idle_inhibitor {
          color: @blue;
        }

        #bluetooth,
        #backlight {
          color: @blue;
        }

        #battery {
          color: @green;
        }

        @keyframes blink {
          to {
            color: @surface0;
          }
        }

        #battery.critical:not(.charging) {
          background-color: @red;
          color: @theme_text_color;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
          box-shadow: inset 0 -3px transparent;
        }

        #custom-updates {
          color: @blue
        }

        #language {
          color: @blue
        }

        #clock {
          color: @yellow;
        }

        #cpu {
          color: @green;
        }

        #custom-keyboard,
        #memory {
          color: @sky;
        }

        #disk {
          color: @sapphire;
        }

        #temperature {
          color: @teal;
        }

        #temperature.critical {
          background-color: @red;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }
        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
        }

        #keyboard-state {
          color: @flamingo;
        }

        #workspaces button {
            box-shadow: none;
        	text-shadow: none;
            padding: 0px;
            border-radius: 9px;
            padding-left: 4px;
            padding-right: 4px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #workspaces button:hover {
        	border-radius: 10px;
        	color: @overlay0;
        	background-color: @surface0;
         	padding-left: 2px;
            padding-right: 2px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #workspaces button.persistent {
        	color: @surface1;
        	border-radius: 10px;
        }

        #workspaces button.active {
        	color: @peach;
          	border-radius: 10px;
            padding-left: 8px;
            padding-right: 8px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #workspaces button.urgent {
        	color: @red;
         	border-radius: 0px;
        }

        #taskbar button.active {
            padding-left: 8px;
            padding-right: 8px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #taskbar button:hover {
            padding-left: 2px;
            padding-right: 2px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #custom-cava_mviz {
        	color: @pink;
        }

        #cava {
        	color: @pink;
        }

        #mpris {
        	color: @pink;
        }

        #custom-menu {
          color: @rosewater;
        }

        #custom-power {
          color: @red;
        }

        #custom-updater {
          color: @red;
        }

        #custom-light_dark {
          color: @blue;
        }

        #custom-weather {
          color: @lavender;
        }

        #custom-lock {
          color: @maroon;
        }

        #pulseaudio {
          color: @sapphire;
        }

        #pulseaudio.bluetooth {
          color: @pink;
        }
        #pulseaudio.muted {
          color: @red;
        }

        #window {
          color: @mauve;
        }

        #custom-waybar-mpris {
          color:@lavender;
        }

        #network {
          color: @teal;
        }
        #network.disconnected,
        #network.disabled {
          background-color: @surface0;
          color: @text;
        }
        #pulseaudio-slider slider {
        	min-width: 0px;
        	min-height: 0px;
        	opacity: 0;
        	background-image: none;
        	border: none;
        	box-shadow: none;
        }

        #pulseaudio-slider trough {
        	min-width: 80px;
        	min-height: 5px;
        	border-radius: 5px;
        }

        #pulseaudio-slider highlight {
        	min-height: 10px;
        	border-radius: 5px;
        }

        #backlight-slider slider {
        	min-width: 0px;
        	min-height: 0px;
        	opacity: 0;
        	background-image: none;
        	border: none;
        	box-shadow: none;
        }

        #backlight-slider trough {
        	min-width: 80px;
        	min-height: 10px;
        	border-radius: 5px;
        }

        #backlight-slider highlight {
        	min-width: 10px;
        	border-radius: 5px;
        }
      '';
      settings = [
        {
          "layer" = "top";
          "position" = "top";
          #"mode" = "dock";
          "height" = 15;
          "exclusive" = true;
          "passthrough" = false;
          "gtk-layer-shell" = true;
          "ipc" = true;
          "fixed-center" = true;
          "margin-top" = 3;
          "margin-left" = 8;
          "margin-right" = 8;

          # "modules-left" = ["hyprland/workspaces" "mpris" "custom/r_end"];
          "modules-left" = ["hyprland/workspaces" "cava" "custom/r_end"];
          "modules-center" = ["custom/l_end" "idle_inhibitor" "clock" "custom/r_end"];
          "modules-right" = ["custom/l_end" "temperature" "cpu" "memory" "keyboard-state" "network" "bluetooth" "pulseaudio" "custom/r_end" "hyprland/language" "custom/r_end" "tray" "battery" "custom/l_end" "custom/power" "custom/padd"];
          #"modules-right" = ["custom/l_end" "temperature" "cpu" "memory" "keyboard-state" "network" "bluetooth" "pulseaudio" "custom/r_end" "hyprland/language" "custom/r_end" "tray" "battery" "custom/l_end" "custom/power" "custom/r_end" "custom/padd" ];
          "custom/colour-temperature" = {
            "format" = "{} ";
            "exec" = "wl-gammarelay-rs watch {t}";
            "on-scroll-up" = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100";
            "on-scroll-down" = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100";
          };
          "custom/cava_mviz" = {
            # DEPRECATED Use builtin cava module instead.
            "exec" = "~/.config/hypr/scripts/WaybarCava.sh";
            "format" = "{}";
          };
          "cava" = {
            "hide_on_silence" = false;
            "framerate" = 30;
            "bars" = 10;
            "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
            "input_delay" = 1;
            # "noise_reduction" = 0.77;
            "sleep_timer" = 5;
            "bar_delimiter" = 0;
          };
          "custom/gpuinfo" = {
            "exec" = " ~/.config/hypr/scripts/gpuinfo.sh";
            "return-type" = "json";
            "format" = " {}";
            "interval" = 5; # once every 5 seconds
            "tooltip" = true;
            "max-length" = 1000;
          };
          "custom/updates" = {
            "exec" = "~/.config/hypr/scripts/systemupdate.sh";
            "return-type" = "json";
            "format" = "󰮯 {}";
            "on-click" = "~/.config/hypr/scripts/systemupdate.sh up";
            "interval" = 86400; # once every day
            "tooltip" = true;
          };
          "mpris" = {
            "format" = "{player_icon} {title} - {artist}";
            "format-paused" = "{status_icon} <i>{title} - {artist}</i>";
            "player-icons" = {
              "default" = "▶";
              "spotify" = "";
              "mpv" = "󰐹";
              "vlc" = "󰕼";
              "firefox" = "";
              "chromium" = "";
              "kdeconnect" = "";
              "mopidy" = "";
            };
            "status-icons" = {
              "paused" = "⏸";
              "playing" = "";
            };
            "ignored-players" = ["firefox" "chromium"];
            "max-length" = 30;
          };
          "temperature" = {
            # "thermal-zone" = 2;
            "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
            "critical-threshold" = 80;
            # "format-critical" = "{temperatureC}°C {icon}";
            "format" = "{icon} {temperatureC}°C";
            "format-icons" = ["" "" ""];
            "interval" = 2;
          };
          "hyprland/language" = {
            "format" = "{short} {variant}";
            "on-click" = "~/.config/hypr/scripts/keyboardswitch.sh";
          };
          "hyprland/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
            "active-only" = false;
            "on-click" = "activate";
            "persistent-workspaces" = {
              "HDMI-A-1" = [1 2 3 4 5 6 7 8 9 10];
              "HDMI-A-2" = [1 2 3 4 5 6 7 8 9 10];
            };
          };

          "hyprland/window" = {
            "format" = "  {}";
            "separate-outputs" = true;
            "rewrite" = {
              "harvey@hyprland =(.*)" = "$1 ";
              "(.*) — Mozilla Firefox" = "$1 󰈹";
              "(.*)Mozilla Firefox" = " Firefox 󰈹";
              "(.*) - Visual Studio Code" = "$1 󰨞";
              "(.*)Visual Studio Code" = "Code 󰨞";
              "(.*) — Dolphin" = "$1 󰉋";
              "(.*)Spotify" = "Spotify 󰓇";
              "(.*)Spotify Premium" = "Spotify 󰓇";
              "(.*)Steam" = "Steam 󰓓";
            };
            "max-length" = 1000;
          };

          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "󰥔";
              "deactivated" = "";
            };
          };

          "clock" = {
            "format" = "{:%R 󰃭 %d·%m·%y}";
            "format-alt" = "{:%I:%M %p}";
            "tooltip-format" = "<tt>{calendar}</tt>";
            "calendar" = {
              "mode" = "month";
              "mode-mon-col" = 3;
              "on-scroll" = 1;
              "on-click-right" = "mode";
              "format" = {
                "months" = "<span color='#ffead3'><b>{}</b></span>";
                "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                "today" = "<span color='#ff6699'><b>{}</b></span>";
              };
            };
            "actions" = {
              "on-click-right" = "mode";
              "on-click-forward" = "tz_up";
              "on-click-backward" = "tz_down";
              "on-scroll-up" = "shift_up";
              "on-scroll-down" = "shift_down";
            };
          };

          "cpu" = {
            "interval" = 10;
            "format" = "󰍛 {usage}%";
            "format-alt" = "{icon0}{icon1}{icon2}{icon3}";
            "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };

          "memory" = {
            "interval" = 30;
            "format" = "󰾆 {percentage}%";
            "format-alt" = "󰾅 {used}GB";
            "max-length" = 10;
            "tooltip" = true;
            "tooltip-format" = " {used =0.1f}GB/{total =0.1f}GB";
          };

          "backlight" = {
            "device" = "intel_backlight";
            "format" = "{icon} {percent}%";
            "format-icons" = ["" "" "" "" "" "" "" "" ""];
            "on-scroll-up" = "brightnessctl set 1%+";
            "on-scroll-down" = "brightnessctl set 1%-";
            "min-length" = 6;
          };

          "network" = {
            # "interface" = "wlp2*"; # (Optional) To force the use of this interface
            "format-wifi" = "󰤨 {essid}";
            "format-ethernet" = "󱘖 Wired";
            "tooltip-format" = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
            "format-linked" = "󱘖 {ifname} (No IP)";
            "format-disconnected" = " Disconnected";
            "format-alt" = "󰤨 {signalStrength}%";
            "interval" = 5;
          };

          "bluetooth" = {
            "format" = "";
            "format-disabled" = ""; # an empty format will hide the module
            "format-connected" = " {num_connections}";
            "tooltip-format" = " {device_alias}";
            "tooltip-format-connected" = "{device_enumerate}";
            "tooltip-format-enumerate-connected" = " {device_alias}";
          };

          "pulseaudio" = {
            "format" = "{icon} {volume}";
            "format-muted" = "婢";
            "on-click" = "pavucontrol -t 3";
            "tooltip-format" = "{icon} {desc} // {volume}%";
            "scroll-step" = 5;
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" "" ""];
            };
          };

          "pulseaudio#microphone" = {
            "format" = "{format_source}";
            "format-source" = "";
            "format-source-muted" = "";
            "on-click" = "pavucontrol -t 4";
            "tooltip-format" = "{format_source} {source_desc} // {source_volume}%";
            "scroll-step" = 5;
          };

          "tray" = {
            "icon-size" = 12;
            "spacing" = 5;
          };

          "battery" = {
            "states" = {
              "good" = 95;
              "warning" = 30;
              "critical" = 20;
            };
            "format" = "{icon} {capacity}%";
            "format-charging" = " {capacity}%";
            "format-plugged" = " {capacity}%";
            "format-alt" = "{time} {icon}";
            "format-icons" = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };

          "custom/power" = {
            "format" = "{}";
            "on-click" = "~/.config/hypr/scripts/Wlogout.sh";
            "interval" = 86400; # once every day
            "tooltip" = true;
          };

          # modules for padding

          "custom/l_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/r_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/sl_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/sr_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/rl_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/rr_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/padd" = {
            "format" = "  ";
            "interval" = "once";
            "tooltip" = false;
          };
        }
      ];
    };
  };
}
