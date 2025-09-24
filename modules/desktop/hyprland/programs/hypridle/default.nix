{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            ignore_dbus_inhibit = false;
            lock_cmd = "pidof hyprlock || hyprlock";
            unlock_cmd = "pkill --signal SIGUSR1 hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300; # 5 Minutes
              on-timeout = "loginctl lock-session";
            }
            /*
              {
                timeout = 360; # 6 Minutes
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            */
            /*
              {
                timeout = 600; # 10m
                on-timeout = "systemctl suspend";
              }
            */
          ];
        };
      };
    })
  ];
}
