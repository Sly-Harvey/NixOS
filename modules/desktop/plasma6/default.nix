{
  lib,
  inputs,
  host,
  pkgs,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    browser
    terminal
    editor
    games
    defaultWallpaper
    ;
in
{
  programs.thunar.enable = lib.mkForce false;
  services = {
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    tlp.enable = lib.mkForce false; # plasma has builtin power management
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    oxygen
    plasma-browser-integration
  ];

  environment.systemPackages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
    })
    bibata-cursors
  ];

  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
      programs.plasma = {
        enable = true;
        immutableByDefault = true;
        krunner.activateWhenTypingOnDesktop = false;
        workspace = {
          clickItemTo = "select"; # select, open
          lookAndFeel = "Catppuccin-Mocha-Mauve"; # Global Theme
          colorScheme =  "CatppuccinMochaMauve";
          theme = "default"; # Plasma Style
          cursor = {
            size = 24;
            theme = "Bibata-Modern-Classic";
          };
          # iconTheme = "";
          wallpaper = "${../../themes/wallpapers/${defaultWallpaper}}"; # TODO: Test webp
        };
        kwin = {
          effects = {
            blur.enable = false;
            cube.enable = true;
            desktopSwitching.animation = "off";
            dimAdminMode.enable = false;
            dimInactive.enable = false;
            fallApart.enable = false;
            fps.enable = false;
            minimization.animation = "off";
            shakeCursor.enable = false;
            slideBack.enable = false;
            snapHelper.enable = false;
            translucency.enable = false;
            windowOpenClose.animation = "off";
            wobblyWindows.enable = false;
          };

          # nightLight = {
          #   enable = true;
          #   location.latitude = "52.23";
          #   location.longitude = "21.01";
          #   mode = "location";
          #   temperature.night = 4000;
          # };

          virtualDesktops = {
            number = 5;
            rows = 1;
          };
        };
        input = {
          keyboard = {
            numlockOnStartup = "on";
            repeatDelay = 275;
            repeatRate = 35;
          };
          mice = [
            {
              acceleration = 1.0;
              accelerationProfile = "none";
              # naturalScroll = true;
              name = builtins.readFile (
                pkgs.runCommand "mousename" { }
                  "grep -B1 -A9 'Mouse' /proc/bus/input/devices | grep 'Name' | cut -d\= -f2 | cut -d'\"' -f2 > $out"
              );
              vendorId = builtins.readFile (
                pkgs.runCommand "vendor" { }
                  "grep -B1 -A9 'Mouse' /proc/bus/input/devices | grep 'I:' | tr ' ' '\n' | grep -v 'I:' | grep -v 'Bus' | grep -v 'Version' | cut -d\= -f2 | head -n1 | tr -d '\n' > $out"
              );
              productId = builtins.readFile (
                pkgs.runCommand "product" { }
                  "grep -B1 -A9 'Mouse' /proc/bus/input/devices | grep 'I:' | tr ' ' '\n' | grep -v 'I:' | grep -v 'Bus' | grep -v 'Version' | cut -d\= -f2 | tail -n1 | tr -d '\n' > $out"
              );
            }
          ];
        };

        panels = [
          {
            screen = "all";
            height = 36;
            widgets = [
              # 0: Workspaces Indicator
              "org.kde.plasma.pager"
              # 1: Spacer
              "org.kde.plasma.panelspacer"

              {
                name = "org.kde.plasma.kickoff";
                config = {
                  General = {
                    # Use the blue NixOS snowflake icon
                    icon = "nix-snowflake";
                  };
                };
              }

              # 2: Apps (Task Manager)
              {
                iconTasks.launchers =
                  lib.optional (browser == "zen") "applications:zen-beta.desktop"
                  ++ [
                    "applications:${terminal}.desktop"
                    "applications:obsidian.desktop"
                  ]
                  ++ lib.optional (
                    editor == "nixvim" || editor == "neovim" || editor == "nvchad"
                  ) "applications:nvim.desktop"
                  ++ lib.optional (games == true) "applications:net.lutris.Lutris.desktop"
                  ++ [
                    "applications:org.kde.dolphin.desktop"
                  ];
              }
              # 3: Spacer
              "org.kde.plasma.panelspacer"
              # 4: System Tray
              "org.kde.plasma.systemtray"
              # 5: System Clock
              "org.kde.plasma.digitalclock"
              # 6: Desktop Peek
              "org.kde.plasma.showdesktop"
            ];
          }
        ];

        shortcuts = {
          "kwin"."Cube" = "Meta+C";
        };
        hotkeys.commands = {
          "launch-${terminal}" = {
            name = "Launch ${terminal}";
            key = "Meta+T";
            command = "${terminal}";
          };
          "launch-${browser}" = {
            name = "Launch ${browser}";
            key = "Meta+F";
            command = "${browser}";
          };
        };
        powerdevil = {
          AC = {
            inhibitLidActionWhenExternalMonitorConnected = true;
            powerButtonAction = "sleep"; # TODO: test sleep on nvidia and if it doesn't work then do shutDown
            powerProfile = "performance";
            whenLaptopLidClosed = "sleep";
            autoSuspend = {
              action = "nothing";
              # idleTimeout = 600;
            };
            turnOffDisplay = {
              idleTimeout = "never";
            };
            # dimDisplay = {
            #   enable = true;
            #   idleTimeout = 300;
            # };
          };
          battery = {
            inhibitLidActionWhenExternalMonitorConnected = true;
            powerButtonAction = "showLogoutScreen";
            powerProfile = "balanced";
            whenLaptopLidClosed = "sleep";
            autoSuspend = {
              action = "sleep";
              idleTimeout = 600;
            };
            turnOffDisplay = {
              idleTimeout = 360; # 6 Minutes
            };
            dimDisplay = {
              enable = true;
              idleTimeout = 120; # 2 Minutes
            };
          };
          batteryLevels = {
            criticalLevel = 5;
            criticalAction = "shutDown";
            # lowLevel = 20;
          };
        };
        kscreenlocker = {
          autoLock = true; # enable toggle
          timeout = 5; # 5 Minutes
          passwordRequired = true;
          passwordRequiredDelay = 0;
          lockOnResume = true;
          # wallpaper = "${../../themes/wallpapers/${defaultWallpaper}}";
        };
        session = {
          general.askForConfirmationOnLogout = false;
          sessionRestore = {
            restoreOpenApplicationsOnLogin = "startWithEmptySession"; # onLastLogout, whenSessionWasManuallySaved, startWithEmptySession
            # excludeApplications = [
            #   "steam"
            #   "xterm"
            # ];
          };
        };
        configFile = {
          # This disables the file indexer for better performance
          "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
        };
      };
    })
  ];
}
