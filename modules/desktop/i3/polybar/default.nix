{ pkgs, ... }:
let
  cava = pkgs.callPackage ./scripts/cava.nix { };
  gpu_temp = pkgs.callPackage ./scripts/gpu_temp.nix { };
  workspaces = pkgs.callPackage ./scripts/workspaces.nix { };
  colors = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
    transparent = "#FF00000";
  };
in
{
  home-manager.sharedModules = [
    (_: {
      services.polybar = {
        enable = true;
        script = ''
          if type "xrandr"; then
            for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
              MONITOR=$m polybar --reload main &
            done
          else
            polybar -q -r main &
          fi
        '';
        settings = {
          colors = colors;
          "bar/main" = {
            width = "100%";
            height = 27;
            radius = 0;
            fixed-center = true;
            background = "${colors.base}";
            foreground = "${colors.text}";
            line-size = 3;
            line-color = "#f00";
            border-size = 0;
            border-color = "#00000000";
            padding-left = 0;
            padding-right = 2;
            module-margin-left = 1;
            module-margin-right = 2;
            font-0 = "monospace;2";
            font-1 = "FontAwesome;2";
            modules-left = "workspaces";
            modules-center = "";
            modules-right = "tray gpu_temp cpu memory pulseaudio wlan eth battery date";
            separator = "|";
            separator-foreground = "${colors.overlay0}";
            cursor-click = "pointer";
            cursor-scroll = "ns-resize";
          };
          "module/tray" = {
            type = "internal/tray";
            tray-spacing = 2;
            tray-padding = 2;
          };

          "module/workspaces" = {
            type = "custom/script";
            exec = "${workspaces}/bin/workspaces";
            tail = true;
          };

          "module/cava" = {
            type = "custom/script";
            exec = "${cava}/bin/cava";
            tail = true;
            format = "<label>";
            label = "%output%";
          };

          "module/gpu_temp" = {
            type = "custom/script";
            exec = "${gpu_temp}/bin/gpu_temp";
            interval = 5;
            format = "<label>";
            label = "%output%";
          };

          "module/cpu" = {
            type = "internal/cpu";
            interval = 2;
            format = "<label>";
            format-prefix = "CPU ";
            format-prefix-foreground = "${colors.mauve}";
            label = "%percentage%%";
          };

          "module/memory" = {
            type = "internal/memory";
            interval = 2;
            format = "<label>";
            format-prefix = "RAM ";
            format-prefix-foreground = "${colors.mauve}";
            label = "%percentage_used%%";
          };

          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            format-volume = "<label-volume> <bar-volume>";
            label-volume = "VOL %percentage%%";
            label-volume-foreground = "${colors.mauve}";
            bar-volume-width = 10;
            bar-volume-foreground-0 = "${colors.green}";
            bar-volume-foreground-1 = "${colors.green}";
            bar-volume-foreground-2 = "${colors.yellow}";
            bar-volume-foreground-3 = "${colors.red}";
            bar-volume-gradient = false;
            bar-volume-indicator = "|";
            bar-volume-fill = "─";
            bar-volume-empty = "─";
            bar-volume-empty-foreground = "${colors.overlay0}";
          };

          "module/wlan" = {
            type = "internal/network";
            # interface = "wlp3s0";
            interval = 3.0;
            format-connected = "<ramp-signal> <label-connected>";
            label-connected = "%essid%";
            ramp-signal-0 = "📶";
            ramp-signal-1 = "📶";
            ramp-signal-2 = "📶";
            ramp-signal-3 = "📶";
            ramp-signal-4 = "📶";
          };

          "module/eth" = {
            type = "internal/network";
            # interface = "enp0s25";
            interval = 3.0;
            format-connected = "<label-connected>";
            label-connected = "ETH %local_ip%";
          };

          "module/battery" = {
            type = "internal/battery";
            battery = "BAT0";
            adapter = "AC";
            full-at = 98;
            format-charging = "<animation-charging> <label-charging>";
            format-discharging = "<ramp-capacity> <label-discharging>";
            format-full = "<ramp-capacity> <label-full>";
            label-charging = "%percentage%%";
            label-discharging = "%percentage%%";
            label-full = "%percentage%%";
            ramp-capacity-0 = "";
            ramp-capacity-1 = "";
            ramp-capacity-2 = "";
            ramp-capacity-3 = "";
            ramp-capacity-4 = "";
            animation-charging-0 = "";
            animation-charging-1 = "";
            animation-charging-2 = "";
            animation-charging-3 = "";
            animation-charging-4 = "";
            animation-charging-framerate = 750;
          };

          "module/date" = {
            type = "internal/date";
            interval = 1;
            date = "%d/%m/%Y";
            time = "%H:%M";
            label = "%date% %time%";
          };
        };
      };
    })
  ];
}
