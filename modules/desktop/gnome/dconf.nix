# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{...}: {
  home-manager.sharedModules = [
    ({lib, ...}:
      with lib.hm.gvariant; {
        dconf.settings = {
          "org/gnome/2048" = {
            window-height = 600;
            window-maximized = false;
            window-width = 600;
          };

          "org/gnome/Console" = {
            last-window-size = mkTuple [1362 743];
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
            last-panel = "info-overview";
            window-state = mkTuple [1660 882 false];
          };

          "org/gnome/desktop/app-folders" = {
            folder-children = ["Utilities" "YaST" "Pardus"];
          };

          "org/gnome/desktop/app-folders/folders/Pardus" = {
            categories = ["X-Pardus-Apps"];
            name = "X-Pardus-Apps.directory";
            translate = true;
          };

          "org/gnome/desktop/app-folders/folders/Utilities" = {
            apps = ["gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop"];
            categories = ["X-GNOME-Utilities"];
            name = "X-GNOME-Utilities.directory";
            translate = true;
          };

          "org/gnome/desktop/app-folders/folders/YaST" = {
            categories = ["X-SuSE-YaST"];
            name = "suse-yast.directory";
            translate = true;
          };

          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };

          "org/gnome/desktop/calendar" = {
            show-weekdate = false;
          };

          "org/gnome/desktop/input-sources" = {
            show-all-sources = false;
            sources = [(mkTuple ["xkb" "gb"])];
            xkb-options = ["terminate:ctrl_alt_bksp"];
          };

          "org/gnome/desktop/interface" = {
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
            gtk-theme = "Catppuccin-Macchiato-Compact-Pink-Dark";
            icon-theme = "Yaru-magenta-dark";
          };

          "org/gnome/desktop/notifications" = {
            application-children = ["org-gnome-tweaks"];
          };

          "org/gnome/desktop/notifications/application/org-gnome-tweaks" = {
            application-id = "org.gnome.tweaks.desktop";
          };

          "org/gnome/desktop/peripherals/mouse" = {
            natural-scroll = false;
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
            sort-order = ["org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop"];
          };

          "org/gnome/desktop/session" = {
            idle-delay = mkUint32 300;
          };

          "org/gnome/desktop/wm/keybindings" = {
            maximize = ["<Super>Up"];
            move-to-monitor-down = ["<Super><Shift>Down"];
            move-to-monitor-left = ["<Super><Shift>Left"];
            move-to-monitor-right = ["<Super><Shift>Right"];
            move-to-monitor-up = ["<Super><Shift>Up"];
            switch-applications = ["<Super>Tab" "<Alt>Tab"];
            switch-applications-backward = ["<Shift><Super>Tab" "<Shift><Alt>Tab"];
            switch-group = ["<Super>Above_Tab" "<Alt>Above_Tab"];
            switch-group-backward = ["<Shift><Super>Above_Tab" "<Shift><Alt>Above_Tab"];
            switch-to-workspace-1 = ["<Super>Home"];
            switch-to-workspace-last = ["<Super>End"];
            switch-to-workspace-left = ["<Super>Page_Up" "<Super><Alt>Left" "<Control><Alt>Left"];
            switch-to-workspace-right = ["<Super>Page_Down" "<Super><Alt>Right" "<Control><Alt>Right"];
            unmaximize = ["<Super>Down" "<Alt>F5"];
          };

          "org/gnome/desktop/wm/preferences" = {
            auto-raise = false;
            button-layout = "close,minimize,maximize:appmenu";
            focus-mode = "sloppy";
            mouse-button-modifier = "<Super>";
            num-workspaces = 10;
            resize-with-right-button = false;
            workspace-names = ["Workspace 1" "Workspace 2" "Workspace 3" "Workspace 4" "Workspace 5" "Workspace 6" "Workspace 7" "Workspace 8" "Workspace 9" "Workspace 10"];
          };

          "org/gnome/evolution-data-server" = {
            migrated = true;
          };

          "org/gnome/gnome-system-monitor" = {
            maximized = false;
            network-total-in-bits = false;
            show-dependencies = false;
            show-whose-processes = "user";
            window-state = mkTuple [700 500 103 103];
          };

          "org/gnome/gnome-system-monitor/disktreenew" = {
            col-6-visible = true;
            col-6-width = 0;
          };

          "org/gnome/mutter" = {
            attach-modal-dialogs = false;
            edge-tiling = false;
            overlay-key = "Super_L";
            workspaces-only-on-primary = false;
          };

          "org/gnome/mutter/keybindings" = {
            cancel-input-capture = ["<Super><Shift>Escape"];
            toggle-tiled-left = ["<Super>Left"];
            toggle-tiled-right = ["<Super>Right"];
          };

          "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = ["<Super>Escape"];
          };

          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "icon-view";
            migrated-gtk-settings = true;
            search-filter-time-type = "last_modified";
          };

          "org/gnome/nautilus/window-state" = {
            initial-size = mkTuple [890 550];
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
            rotate-video-lock-static = ["<Super>o" "XF86RotationLockToggle"];
          };

          "org/gnome/settings-daemon/plugins/power" = {
            power-button-action = "suspend";
            sleep-inactive-ac-type = "suspend";
          };

          "org/gnome/shell" = {
            disabled-extensions = ["native-window-placement@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com"];
            enabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
            favorite-apps = ["org.gnome.Settings.desktop" "org.gnome.Nautilus.desktop" "gnome-system-monitor.desktop" "firefox.desktop" "Alacritty.desktop" "org.gnome.Console.desktop"];
            last-selected-power-profile = "performance";
            welcome-dialog-last-shown-version = "45.4";
          };

          "org/gnome/shell/extensions/burn-my-windows" = {
            active-profile = "/home/${username}/.config/burn-my-windows/profiles/1710415584884218.conf";
            last-extension-version = 39;
            last-prefs-version = 39;
            prefs-open-count = 20;
            show-support-dialog = false;
          };

          "org/gnome/shell/extensions/dash-to-panel" = {
            available-monitors = [0 1];
            primary-monitor = 0;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            accessibility-menu = true;
            background-menu = true;
            controls-manager-spacing-size = 0;
            dash = true;
            dash-icon-size = 0;
            double-super-to-appgrid = true;
            osd = true;
            panel = true;
            panel-in-overview = true;
            ripple-box = true;
            search = true;
            show-apps-button = true;
            startup-status = 1;
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
            restore-attach-modal-dialogs = "";
            restore-edge-tiling = "";
            restore-keybinds = ''
              {}
            '';
            restore-workspaces-only-on-primary = "";
          };

          "org/gnome/shell/extensions/paperwm/workspaces" = {
            list = ["4439950c-0f91-4b4c-bed8-30f5de9a2d70" "40a3ada7-de60-4e16-8078-0980d9eadb05" "b6e86314-3935-4f74-8abe-2cf33e4550ac" "a3e6a893-0a5f-4261-b61b-b7b10b42ce90" "7e03bfff-5d3b-4aae-806e-819c0d638617" "0fcc37bf-6bfa-43bd-baf4-0b59fc226f9c" "cdff165b-99e6-41fe-8da5-330f9cc3cf1f" "9acde03c-4a96-4ef9-92c0-9f54d833038a" "fa8260c0-ab85-47b9-92e2-05f7b3ecd804" "7caee72d-0963-4764-8939-541f9ba731df"];
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

          "org/gnome/shell/keybindings" = {
            focus-active-notification = ["<Super>n"];
            shift-overview-down = ["<Super><Alt>Down"];
            shift-overview-up = ["<Super><Alt>Up"];
          };

          "org/gnome/shell/world-clocks" = {
            locations = [];
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
            window-size = mkTuple [859 372];
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
            window-position = mkTuple [103 103];
            window-size = mkTuple [1231 902];
          };
        };
      })
  ];
}
