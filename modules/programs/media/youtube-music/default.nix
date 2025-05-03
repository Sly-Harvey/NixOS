{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    ({config, ...}: {
      home.packages = with pkgs; [
        youtube-music
        curl
      ];

      xdg.configFile."YouTube Music/config.json".text = ''
        {
          "window-size": {
            "width": 1920,
            "height": 1080
          },
          "window-maximized": true,
          "window-position": {
            "x": 0,
            "y": 0
          },
          "url": "https://music.youtube.com",
          "options": {
            "tray": true,
            "appVisible": true,
            "autoUpdates": false,
            "alwaysOnTop": false,
            "hideMenu": false,
            "hideMenuWarned": false,
            "startAtLogin": false,
            "disableHardwareAcceleration": false,
            "removeUpgradeButton": false,
            "restartOnConfigChanges": false,
            "trayClickPlayPause": false,
            "autoResetAppCache": false,
            "resumeOnStart": true,
            "likeButtons": "",
            "proxy": "",
            "startingPage": "",
            "overrideUserAgent": false,
            "usePodcastParticipantAsArtist": false,
            "themes": [
              "${config.home.homeDirectory}/.config/YouTube Music/themes/catppuccin-mocha.css"
            ]
          },
          "plugins": {
            "notifications": {},
            "video-toggle": {
              "mode": "custom"
            },
            "precise-volume": {
              "globalShortcuts": {}
            },
            "discord": {
              "listenAlong": true
            },
            "bypass-age-restrictions": {
              "enabled": true
            }
          },
          "__internal__": {
            "migrations": {
              "version": "3.9.0"
            }
          }
        }
      '';

      home.activation.makeYoutubeMusicConfigWritable = lib.mkAfter ''
        config_path="$HOME/.config/YouTube Music/config.json"
        default_config="${config.xdg.configFile."YouTube Music/config.json".source}"

        if [ -L "$config_path" ]; then
          rm "$config_path"
          cp "$default_config" "$config_path"
        fi
      '';

      home.activation.fetchYoutubeTheme = lib.mkAfter ''
        export PATH=${pkgs.curl}/bin:$PATH

        THEME_DIR="$HOME/.config/YouTube Music/themes"
        THEME_FILE="$THEME_DIR/catppuccin-mocha.css"

        mkdir -p "$THEME_DIR"
        curl -sSfL "https://raw.githubusercontent.com/catppuccin/youtubemusic/main/src/macchiato.css" -o "$THEME_FILE"
      '';
    })
  ];
}
