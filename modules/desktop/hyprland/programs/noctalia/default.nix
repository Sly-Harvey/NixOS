{
  inputs,
  host,
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
    # wf-recorder
  ];
  home-manager.sharedModules = [
    (_: {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        settings = {
          bar = {
            barType = "floating";
            position = "top";
            density = "default"; # compact, default, comfortable
            showCapsule = false;
            widgetSpacing = 5;
            contentPadding = 2;
            fontScale = 1.05;
            floating = true;
            marginVertical = 8;
            marginHorizontal = 10;
            frameRadius = 12;
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                {
                  emptyColor = "secondary";
                  focusedColor = "primary";
                  followFocusedScreen = false;
                  hideUnoccupied = false;
                  id = "Workspace";
                  labelMode = "none";
                  showLabelsOnlyWhenOccupied = false;
                }
                {
                  colorName = "primary";
                  hideWhenIdle = false;
                  id = "AudioVisualizer";
                  width = 100;
                }
              ];
              center = [
                {
                  iconColor = "none";
                  id = "KeepAwake";
                  textColor = "none";
                }
                {
                  clockColor = "none";
                  customFont = "";
                  formatHorizontal = "ddd, dd MMM HH:mm";
                  formatVertical = "HH mm";
                  id = "Clock";
                  tooltipFormat = "HH:mm ddd, MMM dd";
                  useCustomFont = false;
                }
              ];
              right = [
                {
                  blacklist = [
                    "nm-applet"
                  ];
                  chevronColor = "none";
                  colorizeIcons = false;
                  drawerEnabled = true;
                  hidePassive = false;
                  id = "Tray";
                  pinned = [ ];
                }
                {
                  compactMode = false;
                  diskPath = "/";
                  iconColor = "primary";
                  textColor = "none";
                  id = "SystemMonitor";
                  showCpuFreq = false;
                  showCpuTemp = true;
                  showCpuUsage = true;
                  showDiskAvailable = false;
                  showDiskUsage = false;
                  showDiskUsageAsPercent = false;
                  showGpuTemp = false;
                  showLoadAverage = false;
                  showMemoryAsPercent = false;
                  showMemoryUsage = true;
                  showNetworkStats = false;
                  showSwapUsage = false;
                  useMonospaceFont = true;
                  usePadding = false;
                }
                {
                  displayMode = "onhover";
                  iconColor = "none";
                  id = "Volume";
                  middleClickCommand = "pwvucontrol || pavucontrol";
                  textColor = "none";
                }
                /*
                  {
                    hideWhenZero = false;
                    hideWhenZeroUnread = false;
                    iconColor = "none";
                    id = "NotificationHistory";
                    showUnreadBadge = true;
                    unreadBadgeColor = "primary";
                  }
                */
                {
                  applyToAllMonitors = false;
                  displayMode = "onhover";
                  iconColor = "none";
                  id = "Brightness";
                  textColor = "none";
                }
                {
                  iconColor = "none";
                  id = "NightLight";
                }
                {
                  displayMode = "onhover";
                  iconColor = "none";
                  id = "KeyboardLayout";
                  showIcon = true;
                  textColor = "none";
                }
                {
                  displayMode = "onhover";
                  iconColor = "none";
                  id = "Network";
                  textColor = "none";
                }
                {
                  displayMode = "onhover";
                  iconColor = "none";
                  id = "Bluetooth";
                  textColor = "none";
                }
                {
                  colorizeSystemIcon = "primary";
                  enableColorization = false;
                  generalTooltipText = "Notification Panel";
                  hideMode = "alwaysExpanded";
                  icon = "bell";
                  id = "CustomButton";
                  leftClickExec = "swaync-client -t -sw";
                }
                {
                  deviceNativePath = "__default__";
                  displayMode = "graphic";
                  hideIfIdle = false;
                  hideIfNotDetected = true;
                  id = "Battery";
                  showNoctaliaPerformance = true;
                  showPowerProfiles = false;
                }
                {
                  iconColor = "error";
                  id = "SessionMenu";
                }
              ];
            };
          };
          # colorSchemes = {
          #   useWallpaperColors = false;
          #   predefinedScheme = "Catppuccin";
          #   darkMode = true;
          # };
          general = {
            avatarImage = "${./profile-picture.jpg}";
            radiusRatio = 0.2;
            lockOnSuspend = false;
            showSessionButtonsOnLockScreen = true;
            enableShadows = true;
            showChangelogOnStartup = false;
            telemetryEnabled = false;
          };
          location = {
            monthBeforeDay = true;
            name = "London, United Kingdom";
            weatherEnabled = true;
            weatherShowEffects = true;
            useFahrenheit = false;
            use12hourFormat = false;
            showWeekNumberInCalendar = true;
            showCalendarEvents = true;
            showCalendarWeather = true;
            hideWeatherTimezone = false;
            hideWeatherCityName = false;
          };
          wallpaper = {
            enabled = false;
            directory = "${../../../../wallpapers}";
            setWallpaperOnAllMonitors = true;
          };
          appLauncher = {
            enableSettingsSearch = false;
            enableWindowsSearch = false;
            enableSessionSearch = false;
          };
          controlCenter = {
            shortcuts = {
              left = [
                {
                  id = "Network";
                }
                {
                  id = "Bluetooth";
                }
                {
                  id = "AirplaneMode";
                }
                {
                  id = "WallpaperSelector";
                }
                {
                  id = "NoctaliaPerformance";
                }
              ];
              right = [
                {
                  id = "Notifications";
                }
                {
                  id = "KeepAwake";
                }
                {
                  id = "DarkMode";
                }
                {
                  id = "NightLight";
                }
              ];
            };
            cards = [
              {
                enabled = true;
                id = "profile-card";
              }
              {
                enabled = true;
                id = "shortcuts-card";
              }
              {
                enabled = true;
                id = "audio-card";
              }
              {
                enabled = true;
                id = "brightness-card";
              }
              {
                enabled = true;
                id = "weather-card";
              }
              {
                enabled = true;
                id = "media-sysmon-card";
              }
            ];
          };
          systemMonitor = {
            cpuWarningThreshold = 80;
            cpuCriticalThreshold = 90;
            tempWarningThreshold = 80;
            tempCriticalThreshold = 90;
            gpuWarningThreshold = 80;
            gpuCriticalThreshold = 90;
            memWarningThreshold = 80;
            memCriticalThreshold = 90;
            swapWarningThreshold = 80;
            swapCriticalThreshold = 90;
            diskWarningThreshold = 80;
            diskCriticalThreshold = 90;
            diskAvailWarningThreshold = 20;
            diskAvailCriticalThreshold = 10;
            batteryWarningThreshold = 20;
            batteryCriticalThreshold = 5;
            enableDgpuMonitoring = false;
            useCustomColors = false;
            warningColor = "";
            criticalColor = "";
            externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
          };
          sessionMenu = {
            powerOptions = [
              {
                action = "lock";
                command = "loginctl lock-session";
                countdownEnabled = false;
                enabled = true;
                keybind = "1";
              }
              {
                action = "suspend";
                command = "";
                countdownEnabled = false;
                enabled = true;
                keybind = "2";
              }
              {
                action = "hibernate";
                command = "";
                countdownEnabled = false;
                enabled = false;
                keybind = "3";
              }
              {
                action = "reboot";
                command = "";
                countdownEnabled = false;
                enabled = true;
                keybind = "4";
              }
              {
                action = "logout";
                command = "";
                countdownEnabled = false;
                enabled = true;
                keybind = "5";
              }
              {
                action = "shutdown";
                command = "";
                countdownEnabled = false;
                enabled = true;
                keybind = "6";
              }
              {
                action = "rebootToUefi";
                command = "";
                countdownEnabled = false;
                enabled = false;
                keybind = "7";
              }
            ];
          };
          notifications = {
            enabled = false;
            lowUrgencyDuration = 3;
            normalUrgencyDuration = 8;
            criticalUrgencyDuration = 15;

            enableMediaToast = false;
            enableKeyboardLayoutToast = true;
            enableBatteryToast = true;
            saveToHistory = {
              low = true;
              normal = true;
              critical = true;
            };
          };
          brightness = {
            brightnessStep = true;
            enforceMinimum = true;
            enableDdcSupport = true;
          };
          nightLight = {
            nightTemp = "4000";
            # dayTemp = "6500";
          };
          dock.enabled = false;
          idle.enabled = false;
        };
      };
    })
  ];
}
