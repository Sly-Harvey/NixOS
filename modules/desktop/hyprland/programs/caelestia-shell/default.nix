{
  pkgs,
  inputs,
  host,
  ...
}:

let
  inherit (import ../../../../../hosts/${host}/variables.nix)
    clock24h
    username
    bluetoothSupport
    ;

  caelestiaSettings = {
    appearance.transparency.enabled = true;
    background = {
      enabled = false;
      wallpaperEnabled = false;
      visualiser = {
        enabled = true;
        autoHide = true;
        blur = false;
      };
    };

    bar = {
      clock = {
        showIcon = true;
        showDate = true;
      };
      dragThreshold = 20;
      persistent = true;
      showOnHover = true;
      status = {
        showAudio = true;
        showBattery = true;
        showBluetooth = bluetoothSupport;
        showKbLayout = true;
        showMicrophone = false;
        showNetwork = true;
      };
      workspaces = {
        perMonitorWorkspaces = true;
        activeIndicator = true;
        activeTrail = false;
        showWindows = false;
        shown = 10;
      };
      entries = [
        {
          id = "logo";
          enabled = true;
        }
        {
          id = "workspaces";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "tray";
          enabled = true;
        }
        {
          id = "clock";
          enabled = true;
        }
        {
          id = "statusIcons";
          enabled = true;
        }
        {
          id = "power";
          enabled = true;
        }
      ];
    };

    border = {
      rounding = 25;
      thickness = 10;
    };

    dashboard = {
      enabled = true;
      dragThreshold = 50;
      mediaUpdateInterval = 500;
      showOnHover = true;
    };

    launcher = {
      actionPrefix = ">";
      dragThreshold = 50;
      enableDangerousActions = false;
      maxShown = 9;
      maxWallpapers = 9;
      useFuzzy = {
        apps = true;
        actions = true;
        schemes = true;
        variants = true;
        wallpapers = true;
      };
    };

    notifs = {
      actionOnClick = true;
      clearThreshold = 0.3;
      defaultExpireTimeout = 5000;
      expandThreshold = 20;
      expire = false;
    };

    paths = {
      mediaGif = "root:/assets/bongocat.gif";
      sessionGif = "root:/assets/kurukuru.gif";
      wallpaperDir = "/home/${username}/NixOS/modules/themes/wallpapers";
    };

    services = {
      audioIncrement = "0.1";
      weatherLocation = "51.5,-0.1";
      useFahrenheit = false;
      useTwelveHourClock = !clock24h;
    };

    session = {
      dragThreshold = 30;
      vimKeybinds = true;
      commands = {
        logout = [
          "loginctl"
          "terminate-user"
        ];
        shutdown = [
          "systemctl"
          "poweroff"
        ];
        hibernate = [
          "systemctl"
          "hibernate"
        ];
        reboot = [
          "systemctl"
          "reboot"
        ];
      };
    };

    utilities = {
      enabled = true;
      maxToasts = 4;
      toasts = {
        audioInputChanged = true;
        audioOutputChanged = true;
        capsLockChanged = true;
        chargingChanged = true;
        configLoaded = true;
        dndChanged = true;
        gameModeChanged = true;
        kbLayoutChanged = true;
        kbLimit = true;
        numLockChanged = false;
        vpnChanged = true;
        nowPlaying = false;
      };
    };
  };

  caelestiaShellJson = pkgs.writeText "caelestia-shell.json" (builtins.toJSON caelestiaSettings);
in
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    brightnessctl
  ];

  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      {
        imports = [
          inputs.caelestia-shell.homeManagerModules.default
        ];

        programs.caelestia = {
          enable = true;
          systemd.enable = false;
        };

        home.activation.caelestiaWritableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "${config.xdg.configHome}/caelestia"

          if [ -L "${config.xdg.configHome}/caelestia/shell.json" ]; then
            rm "${config.xdg.configHome}/caelestia/shell.json"
          fi

          install -m 0644 "${caelestiaShellJson}" \
            "${config.xdg.configHome}/caelestia/shell.json"
        '';
      }
    )
  ];
}
