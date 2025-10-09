# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ host, ... }:

let
  inherit (import ../../../hosts/${host}/variables.nix) username kbdLayout defaultWallpaper;
in
{
  home-manager.sharedModules = [
    (
      { lib, ... }:
      with lib.hm.gvariant;
      {
        dconf.settings = {
          "org/blueman/general" = {
            window-properties = [
              529
              350
              0
              0
            ];
          };

          "org/gnome/2048" = {
            window-height = 600;
            window-maximized = false;
            window-width = 600;
          };

          "org/gnome/Console" = {
            last-window-size = mkTuple [
              1362
              743
            ];
          };

          "org/gnome/Extensions" = {
            window-height = 1028;
            window-maximized = false;
          };

          "org/gnome/Geary" = {
            migrated-config = true;
          };

          "org/gnome/Music" = {
            window-maximized = true;
          };

          "org/gnome/Robots" = {
            window-height = 566;
            window-width = 720;
          };

          "org/gnome/control-center" = {
            last-panel = "mouse";
            window-state = mkTuple [
              1717
              937
              true
            ];
          };

          "org/gnome/desktop/a11y/mouse" = {
            dwell-click-enabled = false;
          };

          "org/gnome/desktop/app-folders" = {
            folder-children = [
              "Utilities"
              "YaST"
              "Pardus"
            ];
          };

          "org/gnome/desktop/app-folders/folders/Pardus" = {
            categories = [ "X-Pardus-Apps" ];
            name = "X-Pardus-Apps.directory";
            translate = true;
          };

          "org/gnome/desktop/app-folders/folders/Utilities" = {
            apps = [
              "gnome-abrt.desktop"
              "gnome-system-log.desktop"
              "nm-connection-editor.desktop"
              "org.gnome.baobab.desktop"
              "org.gnome.Connections.desktop"
              "org.gnome.DejaDup.desktop"
              "org.gnome.Dictionary.desktop"
              "org.gnome.DiskUtility.desktop"
              "org.gnome.Evince.desktop"
              "org.gnome.FileRoller.desktop"
              "org.gnome.fonts.desktop"
              "org.gnome.Loupe.desktop"
              "org.gnome.seahorse.Application.desktop"
              "org.gnome.tweaks.desktop"
              "org.gnome.Usage.desktop"
              "vinagre.desktop"
            ];
            categories = [ "X-GNOME-Utilities" ];
            name = "X-GNOME-Utilities.directory";
            translate = true;
          };

          "org/gnome/desktop/app-folders/folders/YaST" = {
            categories = [ "X-SuSE-YaST" ];
            name = "suse-yast.directory";
            translate = true;
          };

          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "file://${../../themes/wallpapers/${defaultWallpaper}}";
            picture-uri-dark = "file://${../../themes/wallpapers/${defaultWallpaper}}";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };

          "org/gnome/desktop/break-reminders/eyesight" = {
            play-sound = true;
          };

          "org/gnome/desktop/break-reminders/movement" = {
            duration-seconds = mkUint32 300;
            interval-seconds = mkUint32 1800;
            play-sound = true;
          };

          "org/gnome/desktop/calendar" = {
            show-weekdate = false;
          };

          "org/gnome/desktop/input-sources" = {
            show-all-sources = false;
            sources = [
              (mkTuple [
                "xkb"
                "${kbdLayout}"
              ])
            ];
            xkb-options = [
              "terminate:ctrl_alt_bksp"
              "custom:types"
            ];
          };

          "org/gnome/desktop/interface" = {
            accent-color = "blue";
            clock-show-date = true;
            clock-show-seconds = true;
            clock-show-weekday = true;
            color-scheme = "prefer-dark";
            cursor-size = 24;
            cursor-theme = "Bibata-Modern-Classic";
            enable-animations = true;
            enable-hot-corners = false;
            font-antialiasing = "grayscale";
            font-hinting = "slight";
            gtk-theme = "catppuccin-mocha-mauve-compact";
            icon-theme = "Papirus-Dark";
            # show-battery-percentage = true;
          };

          "org/gnome/desktop/notifications" = {
            application-children = [
              "org-gnome-tweaks"
              "gnome-power-panel"
            ];
          };

          "org/gnome/desktop/notifications/application/gnome-power-panel" = {
            application-id = "gnome-power-panel.desktop";
          };

          "org/gnome/desktop/notifications/application/org-gnome-tweaks" = {
            application-id = "org.gnome.tweaks.desktop";
          };

          "org/gnome/desktop/peripherals/keyboard" = {
            delay = mkUint32 223;
            repeat-interval = mkUint32 21;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            natural-scroll = false;
            speed = 0.33603238866396756;
          };

          "org/gnome/desktop/peripherals/tablets/056a:037a" = {
            keep-aspect = false;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            disable-while-typing = true;
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/desktop/privacy" = {
            disable-microphone = false;
            old-files-age = mkUint32 3;
            recent-files-max-age = -1;
            remember-recent-files = true;
            remove-old-temp-files = true;
            remove-old-trash-files = true;
          };

          "org/gnome/desktop/screensaver" = {
            color-shading-type = "solid";
            lock-enabled = true;
            picture-options = "zoom";
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };

          "org/gnome/desktop/search-providers" = {
            sort-order = [
              "org.gnome.Contacts.desktop"
              "org.gnome.Documents.desktop"
              "org.gnome.Nautilus.desktop"
            ];
          };

          "org/gnome/desktop/session" = {
            idle-delay = mkUint32 300;
          };

          "org/gnome/desktop/wm/keybindings" = {
            close = [
              "<Super>q"
              "<Alt>F4"
            ];
            maximize = [ "<Super>Up" ];
            minimize = [ "<Alt><Super>h" ];
            move-to-monitor-down = [ "<Super><Shift>Down" ];
            move-to-monitor-left = [ "<Super><Shift>Left" ];
            move-to-monitor-right = [ "<Super><Shift>Right" ];
            move-to-monitor-up = [ "<Super><Shift>Up" ];
            move-to-workspace-1 = [ "<Shift><Super>1" ];
            move-to-workspace-2 = [ "<Shift><Super>2" ];
            move-to-workspace-3 = [ "<Shift><Super>3" ];
            move-to-workspace-4 = [ "<Shift><Super>4" ];
            move-to-workspace-5 = [ "<Shift><Super>5" ];
            move-to-workspace-6 = [ "<Shift><Super>6" ];
            move-to-workspace-7 = [ "<Shift><Super>7" ];
            move-to-workspace-8 = [ "<Shift><Super>8" ];
            move-to-workspace-9 = [ "<Shift><Super>9" ];
            move-to-workspace-10 = [ "<Shift><Super>10" ];
            move-to-workspace-down = [ "<Control><Shift><Alt>Down" ];
            move-to-workspace-left = [
              "<Super><Shift>Page_Up"
              "<Super><Shift><Alt>Left"
              "<Control><Shift><Alt>Left"
            ];
            move-to-workspace-right = [
              "<Super><Shift>Page_Down"
              "<Super><Shift><Alt>Right"
              "<Control><Shift><Alt>Right"
            ];
            move-to-workspace-up = [ "<Control><Shift><Alt>Up" ];
            switch-applications = [
              "<Super>Tab"
              "<Alt>Tab"
            ];
            switch-applications-backward = [
              "<Shift><Super>Tab"
              "<Shift><Alt>Tab"
            ];
            switch-group = [
              "<Super>Above_Tab"
              "<Alt>Above_Tab"
            ];
            switch-group-backward = [
              "<Shift><Super>Above_Tab"
              "<Shift><Alt>Above_Tab"
            ];
            switch-panels = [ "<Control><Alt>Tab" ];
            switch-panels-backward = [ "<Shift><Control><Alt>Tab" ];
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            switch-to-workspace-5 = [ "<Super>5" ];
            switch-to-workspace-6 = [ "<Super>6" ];
            switch-to-workspace-7 = [ "<Super>7" ];
            switch-to-workspace-8 = [ "<Super>8" ];
            switch-to-workspace-9 = [ "<Super>9" ];
            switch-to-workspace-10 = [ "<Super>0" ];
            switch-to-workspace-last = [ "<Super>End" ];
            switch-to-workspace-left = [ "<Super>h" ];
            switch-to-workspace-right = [ "<Super>l" ];
            unmaximize = [
              "<Super>Down"
              "<Alt>F5"
            ];
          };

          "org/gnome/desktop/wm/preferences" = {
            auto-raise = false;
            button-layout = "appmenu:minimize,maximize,close";
            focus-mode = "sloppy";
            mouse-button-modifier = "<Super>";
            num-workspaces = 10;
            resize-with-right-button = false;
            workspace-names = [
              "Workspace 1"
              "Workspace 2"
              "Workspace 3"
              "Workspace 4"
              "Workspace 5"
              "Workspace 6"
              "Workspace 7"
              "Workspace 8"
              "Workspace 9"
              "Workspace 10"
            ];
          };

          "org/gnome/evolution-data-server" = {
            migrated = true;
          };

          "org/gnome/file-roller/dialogs/extract" = {
            height = 800;
            recreate-folders = true;
            skip-newer = false;
            width = 1000;
          };

          "org/gnome/file-roller/dialogs/new" = {
            default-extension = ".tar.gz";
            encrypt-header = false;
            volume-size = 104857;
          };

          "org/gnome/file-roller/file-selector" = {
            show-hidden = false;
            sidebar-size = 300;
            sort-method = "name";
            sort-type = "ascending";
            window-size = mkTuple [
              (-1)
              (-1)
            ];
          };

          "org/gnome/file-roller/listing" = {
            list-mode = "as-folder";
            name-column-width = 393;
            show-path = false;
            sort-method = "name";
            sort-type = "ascending";
          };

          "org/gnome/file-roller/ui" = {
            sidebar-width = 200;
            window-height = 480;
            window-width = 600;
          };

          "org/gnome/gnome-system-monitor" = {
            current-tab = "disks";
            maximized = false;
            network-total-in-bits = false;
            show-dependencies = false;
            show-whose-processes = "user";
            window-height = 720;
            window-state = mkTuple [
              700
              500
              103
              103
            ];
            window-width = 800;
          };

          "org/gnome/gnome-system-monitor/disktreenew" = {
            col-6-visible = true;
            col-6-width = 0;
          };

          "org/gnome/gnome-system-monitor/proctree" = {
            col-26-visible = false;
            col-26-width = 0;
          };

          "org/gnome/mutter" = {
            attach-modal-dialogs = false;
            dynamic-workspaces = false;
            edge-tiling = false;
            overlay-key = "Super_L";
            workspaces-only-on-primary = false;
          };

          "org/gnome/mutter/keybindings" = {
            cancel-input-capture = [ "<Super><Shift>Escape" ];
            toggle-tiled-left = [ "<Super>Left" ];
            toggle-tiled-right = [ "<Super>Right" ];
          };

          "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = [ "<Super>Escape" ];
          };

          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "icon-view";
            migrated-gtk-settings = true;
            search-filter-time-type = "last_modified";
          };

          "org/gnome/nautilus/window-state" = {
            initial-size = mkTuple [
              890
              550
            ];
            initial-size-file-chooser = mkTuple [
              890
              550
            ];
            maximized = false;
          };

          "org/gnome/nm-applet/eap/8f48a931-08b8-42dc-ad93-792d3529eb46" = {
            ignore-ca-cert = false;
            ignore-phase2-ca-cert = false;
          };

          "org/gnome/nm-applet/eap/fa7bd633-bf76-414d-b642-c78118eb23b9" = {
            ignore-ca-cert = false;
            ignore-phase2-ca-cert = false;
          };

          "org/gnome/portal/filechooser/org/gnome/Settings" = {
            last-folder-path = "/home/${username}/Downloads";
          };

          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = false;
            night-light-schedule-automatic = false;
            night-light-schedule-from = 0.0;
            night-light-schedule-to = 23.983333;
            night-light-temperature = mkUint32 2700;
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            control-center = [ "<Super>i" ];
            rotate-video-lock-static = [
              "<Super>o"
              "XF86RotationLockToggle"
            ];
            screensaver = [ "<Alt><Super>l" ];
            www = [ "<Super>f" ];
          };

          "org/gnome/settings-daemon/plugins/power" = {
            power-button-action = "suspend";
            sleep-inactive-ac-type = "suspend";
          };

          "org/gnome/shell" = {
            disable-user-extensions = false;
            disabled-extensions = [
              "native-window-placement@gnome-shell-extensions.gcampax.github.com"
              "window-list@gnome-shell-extensions.gcampax.github.com"
              "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
              "appindicatorsupport@rgcjonas.gmail.com"
              "arcmenu@arcmenu.com"
              "blur-my-shell@aunetx"
              "burn-my-windows@schneegans.github.com"
              "custom-accent-colors@demiskp"
              "dash-to-panel@jderose9.github.com"
              "gTile@vibou"
              "gnome-compact-top-bar@metehan-arslan.github.io"
              "just-perfection-desktop@just-perfection"
              "paperwm@paperwm.github.com"
              "trayIconsReloaded@selfmade.pl"
            ];
            enabled-extensions = [
              "apps-menu@gnome-shell-extensions.gcampax.github.com"
              "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
              "places-menu@gnome-shell-extensions.gcampax.github.com"
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
              "Vitals@CoreCoding.com"
            ];
            favorite-apps = [
              "org.gnome.Settings.desktop"
              "org.gnome.Nautilus.desktop"
              "gnome-system-monitor.desktop"
              "firefox.desktop"
              "Alacritty.desktop"
              "org.gnome.Console.desktop"
            ];
            last-selected-power-profile = "performance";
            welcome-dialog-last-shown-version = "45.4";
          };

          "org/gnome/shell/app-switcher" = {
            current-workspace-only = false;
          };

          "org/gnome/shell/extensions/appindicator" = {
            icon-brightness = 0.0;
            icon-contrast = 0.0;
            icon-opacity = 240;
            icon-saturation = 0.0;
            icon-size = 0;
          };

          "org/gnome/shell/extensions/arcmenu" = {
            update-notifier-project-version = 65;
          };

          "org/gnome/shell/extensions/blur-my-shell" = {
            settings-version = 2;
          };

          "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
            brightness = 0.6;
            sigma = 30;
          };

          "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
            pipeline = "pipeline_default";
          };

          "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
            blur = true;
            brightness = 0.6;
            pipeline = "pipeline_default_rounded";
            sigma = 30;
            static-blur = true;
            style-dash-to-dock = 0;
          };

          "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
            pipeline = "pipeline_default";
          };

          "org/gnome/shell/extensions/blur-my-shell/overview" = {
            pipeline = "pipeline_default";
          };

          "org/gnome/shell/extensions/blur-my-shell/panel" = {
            brightness = 0.6;
            pipeline = "pipeline_default";
            sigma = 30;
          };

          "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
            pipeline = "pipeline_default";
          };

          "org/gnome/shell/extensions/blur-my-shell/window-list" = {
            brightness = 0.6;
            sigma = 30;
          };

          "org/gnome/shell/extensions/burn-my-windows" = {
            active-profile = "/home/${username}/.config/burn-my-windows/profiles/1758940449409036.conf";
            last-extension-version = 39;
            last-prefs-version = 46;
            prefs-open-count = 20;
            show-support-dialog = false;
          };

          "org/gnome/shell/extensions/dash-to-panel" = {
            animate-appicon-hover = false;
            appicon-margin = 4;
            appicon-style = "NORMAL";
            available-monitors = [
              0
              1
            ];
            dot-position = "BOTTOM";
            dot-style-focused = "METRO";
            extension-version = 68;
            global-border-radius = 0;
            highlight-appicon-hover = true;
            hotkeys-overlay-combo = "TEMPORARILY";
            intellihide = false;
            multi-monitors = true;
            panel-anchors = ''
              {"BNQ-99J01861SL0":"MIDDLE","BNQ-PCK00489SL0":"MIDDLE","BNQ-99D06760SL0":"MIDDLE"}
            '';
            panel-element-positions = ''
              {"BNQ-99J01861SL0":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}
            '';
            panel-element-positions-monitors-sync = false;
            panel-lengths = ''
              {"BNQ-99J01861SL0":100}
            '';
            panel-positions = ''
              {}
            '';
            panel-sizes = ''
              {"BNQ-99J01861SL0":22,"BNQ-PCK00489SL0":40,"BNQ-99D06760SL0":22}
            '';
            prefs-opened = false;
            primary-monitor = "BNQ-PCK00489SL0";
            stockgs-keep-dash = false;
            stockgs-keep-top-panel = false;
            trans-use-custom-bg = false;
            window-preview-title-position = "TOP";
          };

          "org/gnome/shell/extensions/gtile" = {
            auto-close = true;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            accessibility-menu = true;
            background-menu = true;
            controls-manager-spacing-size = 0;
            dash = true;
            dash-icon-size = 0;
            double-super-to-appgrid = true;
            max-displayed-search-results = 0;
            osd = true;
            panel = true;
            panel-in-overview = true;
            ripple-box = true;
            search = true;
            show-apps-button = true;
            startup-status = 1;
            support-notifier-showed-version = 34;
            support-notifier-type = 0;
            theme = false;
            window-demands-attention-focus = false;
            window-picker-icon = true;
            window-preview-caption = true;
            window-preview-close-button = true;
            workspace = true;
            workspace-background-corner-size = 0;
            workspace-popup = true;
            workspaces-in-app-grid = true;
          };

          "org/gnome/shell/extensions/paperwm" = {
            last-used-display-server = "Wayland";
            restore-attach-modal-dialogs = "";
            restore-edge-tiling = "";
            restore-keybinds = ''
              {}
            '';
            restore-workspaces-only-on-primary = "";
          };

          "org/gnome/shell/extensions/paperwm/workspaces" = {
            list = [
              "4439950c-0f91-4b4c-bed8-30f5de9a2d70"
              "40a3ada7-de60-4e16-8078-0980d9eadb05"
              "b6e86314-3935-4f74-8abe-2cf33e4550ac"
              "a3e6a893-0a5f-4261-b61b-b7b10b42ce90"
              "7e03bfff-5d3b-4aae-806e-819c0d638617"
              "0fcc37bf-6bfa-43bd-baf4-0b59fc226f9c"
              "cdff165b-99e6-41fe-8da5-330f9cc3cf1f"
              "9acde03c-4a96-4ef9-92c0-9f54d833038a"
              "fa8260c0-ab85-47b9-92e2-05f7b3ecd804"
              "7caee72d-0963-4764-8939-541f9ba731df"
            ];
          };

          "org/gnome/shell/extensions/paperwm/workspaces/0fcc37bf-6bfa-43bd-baf4-0b59fc226f9c" = {
            index = 5;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/40a3ada7-de60-4e16-8078-0980d9eadb05" = {
            index = 1;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/4439950c-0f91-4b4c-bed8-30f5de9a2d70" = {
            index = 0;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/7caee72d-0963-4764-8939-541f9ba731df" = {
            index = 9;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/7e03bfff-5d3b-4aae-806e-819c0d638617" = {
            index = 4;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/9acde03c-4a96-4ef9-92c0-9f54d833038a" = {
            index = 7;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/a3e6a893-0a5f-4261-b61b-b7b10b42ce90" = {
            index = 3;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/b6e86314-3935-4f74-8abe-2cf33e4550ac" = {
            index = 2;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/cdff165b-99e6-41fe-8da5-330f9cc3cf1f" = {
            index = 6;
          };

          "org/gnome/shell/extensions/paperwm/workspaces/fa8260c0-ab85-47b9-92e2-05f7b3ecd804" = {
            index = 8;
          };

          "org/gnome/shell/extensions/vitals" = {
            alphabetize = true;
            fixed-widths = true;
            hide-icons = false;
            hot-sensors = [
              "_gpu#1_temperature_"
              "_processor_usage_"
              "_memory_usage_"
            ];
            icon-style = 0;
            menu-centered = false;
            position-in-panel = 2;
            show-battery = true;
            show-gpu = true;
            use-higher-precision = false;
          };

          "org/gnome/shell/keybindings" = {
            focus-active-notification = [ "<Super>n" ];
            shift-overview-down = [ "<Super><Alt>Down" ];
            shift-overview-up = [ "<Super><Alt>Up" ];
            switch-to-application-1 = [ ];
            switch-to-application-2 = [ ];
            switch-to-application-3 = [ ];
            switch-to-application-4 = [ ];
            switch-to-application-5 = [ ];
            switch-to-application-6 = [ ];
            switch-to-application-7 = [ ];
            switch-to-application-8 = [ ];
            switch-to-application-9 = [ ];
            switch-to-application-10 = [ ];
            toggle-message-tray = [
              "<Super>v"
              "<Super>m"
            ];
          };

          "org/gnome/shell/world-clocks" = {
            locations = [ ];
          };

          "org/gnome/tweaks" = {
            show-extensions-notice = false;
          };

          "org/gtk/gtk4/settings/file-chooser" = {
            date-format = "regular";
            location-mode = "path-bar";
            show-hidden = false;
            show-size-column = true;
            show-type-column = true;
            sidebar-width = 140;
            sort-column = "name";
            sort-directories-first = true;
            sort-order = "ascending";
            type-format = "category";
            view-type = "list";
            window-size = mkTuple [
              859
              372
            ];
          };

          "org/gtk/settings/file-chooser" = {
            date-format = "regular";
            location-mode = "path-bar";
            show-hidden = false;
            show-size-column = true;
            show-type-column = true;
            sidebar-width = 161;
            sort-column = "name";
            sort-directories-first = false;
            sort-order = "ascending";
            type-format = "category";
            window-position = mkTuple [
              103
              103
            ];
            window-size = mkTuple [
              1231
              902
            ];
          };

          "org/virt-manager/virt-manager" = {
            manager-window-height = 1016;
            manager-window-width = 1898;
          };

          "org/virt-manager/virt-manager/vmlist-fields" = {
            disk-usage = false;
            network-traffic = false;
          };

        };
      }
    )
  ];
}
