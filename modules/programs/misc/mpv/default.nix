{
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    ({config, ...}: {
      programs.mpv = {
        enable = true;
        defaultProfiles = ["gpu-hq"];
        scripts = with pkgs.mpvScripts; [
          thumbnail
          mpris
        ];
        bindings = rec {
          MBTN_LEFT_DBL = "cycle fullscreen";
          MBTN_RIGHT = "cycle pause";
          MBTN_BACK = "playlist-prev";
          MBTN_FORWARD = "playlist-next";
          WHEEL_DOWN = "seek -5";
          WHEEL_UP = "seek 5";
          WHEEL_LEFT = "seek -60";
          WHEEL_RIGHT = "seek 60";

          h = "no-osd seek -5 exact";
          LEFT = h;
          l = "no-osd seek 5 exact";
          RIGHT = l;
          j = "seek -30";
          DOWN = j;
          k = "seek 30";
          UP = k;

          H = "no-osd seek -1 exact";
          "Shift+LEFT" = "no-osd seek -1 exact";
          L = "no-osd seek 1 exact";
          "Shift+RIGHT" = "no-osd seek 1 exact";
          J = "seek -300";
          "Shift+DOWN" = "seek -300";
          K = "seek 300";
          "Shift+UP" = "seek 300";

          "Ctrl+LEFT" = "no-osd sub-seek -1";
          "Ctrl+h" = "no-osd sub-seek -1";
          "Ctrl+RIGHT" = "no-osd sub-seek 1";
          "Ctrl+l" = "no-osd sub-seek 1";
          "Ctrl+DOWN" = "add chapter -1";
          "Ctrl+j" = "add chapter -1";
          "Ctrl+UP" = "add chapter 1";
          "Ctrl+k" = "add chapter 1";

          "Alt+LEFT" = "frame-back-step";
          "Alt+h" = "frame-back-step";
          "Alt+RIGHT" = "frame-step";
          "Alt+l" = "frame-step";

          PGUP = "add chapter 1";
          PGDWN = "add chapter -1";

          u = "revert-seek";

          "Ctrl++" = "add sub-scale 0.1";
          "Ctrl+-" = "add sub-scale -0.1";
          "Ctrl+0" = "set sub-scale 0";

          q = "quit";
          Q = "quit-watch-later";
          "q {encode}" = "quit 4";
          p = "cycle pause";
          SPACE = p;
          f = "cycle fullscreen";

          n = "playlist-next";
          N = "playlist-prev";

          o = "show-progress";
          O = "script-binding stats/display-stats-toggle";
          "`" = "script-binding console/enable";
          ":" = "script-binding console/enable";

          z = "add sub-delay -0.1";
          x = "add sub-delay 0.1";
          Z = "add audio-delay -0.1";
          X = "add audio-delay 0.1";

          "1" = "add volume -1";
          "2" = "add volume 1";
          s = "cycle sub";
          v = "cycle video";
          a = "cycle audio";
          S = ''cycle-values sub-ass-override "force" "no"'';
          PRINT = "screenshot";
          c = "add panscan 0.1";
          C = "add panscan -0.1";
          PLAY = "cycle pause";
          PAUSE = "cycle pause";
          PLAYPAUSE = "cycle pause";
          PLAYONLY = "set pause no";
          PAUSEONLY = "set pause yes";
          STOP = "stop";
          CLOSE_WIN = "quit";
          "CLOSE_WIN {encode}" = "quit 4";
          "Ctrl+w" = ''set hwdec "no"'';
          # T = "script-binding generate-thumbnails";
        };
        config = {
          osc = "no";
          watch-later-directory = "${config.xdg.stateHome}/mpv/watch_later";
          resume-playback-check-mtime = true;
          audio-device = "pipewire";
          # because ao=pipewire doesn't work for audio-only files for whatever reason...
          # TODO: hopefully remove it when it's fixed upstream
          ao = "pipewire";
          audio-file-auto = "fuzzy";
          sub-auto = "fuzzy";
          # gpu-context = "waylandvk";
          wayland-edge-pixels-pointer = 0;
          wayland-edge-pixels-touch = 0;
          screenshot-format = "webp";
          screenshot-webp-lossless = true;
          screenshot-directory = "${config.home.homeDirectory}/Pictures/Screenshots/mpv";
          screenshot-sw = true;
          cache-dir = "${config.xdg.cacheHome}/mpv";
          input-default-bindings = false;
        };
      };
    })
  ];
}
