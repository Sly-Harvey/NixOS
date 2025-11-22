{ ... }:
{
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil"; # schedutil powersave, ondemand

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power"; # power, balance_power
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      # Protect battery
      START_CHARGE_THRESH_BAT0 = 82;
      STOP_CHARGE_THRESH_BAT0 = 95;
      START_CHARGE_THRESH_BAT1 = 82;
      STOP_CHARGE_THRESH_BAT1 = 95;
    };
  };
}
