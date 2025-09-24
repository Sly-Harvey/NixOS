{
  pkgs,
  lib,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        ytMusicConfig = {
          window-size = {
            width = 1920;
            height = 1080;
          };
          window-maximized = true;
          window-position = {
            x = 0;
            y = 0;
          };
          url = "https://music.youtube.com";
          options = {
            tray = true;
            appVisible = true;
            autoUpdates = false;
            alwaysOnTop = false;
            hideMenu = false;
            hideMenuWarned = false;
            startAtLogin = false;
            disableHardwareAcceleration = false;
            removeUpgradeButton = false;
            restartOnConfigChanges = false;
            trayClickPlayPause = false;
            autoResetAppCache = false;
            resumeOnStart = false;
            likeButtons = "force";
            proxy = "";
            startingPage = "";
            overrideUserAgent = false;
            usePodcastParticipantAsArtist = false;
            themes = [
              "${config.home.homeDirectory}/.config/YouTube Music/themes/catppuccin-mocha.css"
            ];
          };
          plugins = {
            notifications.enabled = false; # Currently not working when config.json is symlink
            video-toggle.mode = "custom";
            precise-volume = {
              globalShortcuts = { };
              enabled = true;
            };
            discord.listenAlong = true;
            bypass-age-restrictions.enabled = true;
            sponsorblock.enabled = true;
            downloader.enabled = true;
            audio-compressor.enabled = false;
            blur-nav-bar.enabled = false;
            equalizer.enabled = false;
            ambient-mode.enabled = false;
            amuse.enabled = false;
            visualizer = {
              enabled = false;
              type = "vudio";
              butterchurn = {
                preset = "martin [shadow harlequins shape code] - fata morgana";
                renderingFrequencyInMs = 500;
                blendTimeInSeconds = 2.7;
              };
              vudio = {
                effect = "lighting";
                accuracy = 128;
                lighting = {
                  maxHeight = 160;
                  maxSize = 12;
                  lineWidth = 1;
                  color = "#49f3f7";
                  shadowBlur = 2;
                  shadowColor = "rgba(244,244,244,.5)";
                  fadeSide = true;
                  prettify = false;
                  horizontalAlign = "center";
                  verticalAlign = "middle";
                  dottify = true;
                };
              };
              wave = {
                animations = [
                  {
                    type = "Cubes";
                    config = {
                      bottom = true;
                      count = 30;
                      cubeHeight = 5;
                      fillColor = {
                        gradient = [
                          "#FAD961"
                          "#F76B1C"
                        ];
                      };
                      lineColor = "rgba(0,0,0,0)";
                      radius = 20;
                    };
                  }
                  {
                    type = "Cubes";
                    config = {
                      top = true;
                      count = 12;
                      cubeHeight = 5;
                      fillColor = {
                        gradient = [
                          "#FAD961"
                          "#F76B1C"
                        ];
                      };
                      lineColor = "rgba(0,0,0,0)";
                      radius = 10;
                    };
                  }
                  {
                    type = "Circles";
                    config = {
                      lineColor = {
                        gradient = [
                          "#FAD961"
                          "#FAD961"
                          "#F76B1C"
                        ];
                        rotate = 90;
                      };
                      lineWidth = 4;
                      diameter = 20;
                      count = 10;
                      frequencyBand = "base";
                    };
                  }
                ];
              };
            };
          };
          __internal__ = {
            migrations = {
              version = "3.9.0";
            };
          };
        };
      in
      {
        home.packages = with pkgs; [
          youtube-music
          curl
        ];

        xdg.configFile."YouTube Music/config.json".text = builtins.toJSON ytMusicConfig;

        # Fetch the theme
        home.activation.fetchYoutubeTheme = lib.mkAfter ''
          if ! [ -f "$HOME/.config/YouTube Music/themes/catppuccin-mocha.css" ]; then
            export PATH=${pkgs.curl}/bin:$PATH
            THEME_DIR="$HOME/.config/YouTube Music/themes"
            THEME_FILE="$THEME_DIR/catppuccin-mocha.css"
            mkdir -p "$THEME_DIR"
            curl -sSfL "https://raw.githubusercontent.com/catppuccin/youtubemusic/main/src/macchiato.css" -o "$THEME_FILE"
          fi
        '';

        # make the config writable (may cause home-manager conflicts)
        # home.activation.makeYoutubeMusicConfigWritable = lib.mkAfter ''
        #   config_path="$HOME/.config/YouTube Music/config.json"
        #   default_config="${config.xdg.configFile."YouTube Music/config.json".source}"
        #   if [ -L "$config_path" ]; then
        #     rm "$config_path"
        #     cp "$default_config" "$config_path"
        #   fi
        # '';
      }
    )
  ];
}
