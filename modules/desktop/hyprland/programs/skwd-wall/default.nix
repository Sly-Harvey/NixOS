{ pkgs, ... }:
let
  wallpaperDir = "${../../../../themes/wallpapers}";
in
{
  home-manager.sharedModules = [
    (_: {
      # comment to disable matugen theming
      home.packages = [ pkgs.matugen ];

      xdg.configFile."skwd-wall/config.json" = {
        text = builtins.toJSON {
          compositor = "hyprland";
          monitor = "";
          general = {
            locale = "";
            closeOnSelection = false;
            reopenAtLastSelection = false;
          };
          paths = {
            wallpaper = wallpaperDir;
            videoWallpaper = wallpaperDir;
            cache = "";
            templates = "";
            scripts = "";
            steam = "";
            steamWorkshop = "";
            steamWeAssets = "";
          };
          features = {
            matugen = true;
            ollama = false;
            steam = false;
            wallhaven = true;
          };
          colorSource = "magick";
          ollama = {
            url = "http://localhost:11434";
            model = "gemma3:4b";
            consolidateEnabled = true;
          };
          steam = {
            apiKey = "";
            username = "";
          };
          wallhaven = {
            apiKey = "";
          };
          matugen = {
            schemeType = "scheme-fidelity";
            mode = "dark";
          };
          integrations = [
            {
              name = "skwd-wall";
              template = "quickshell-colors.json";
              output = "colors.json";
            }
            {
              name = "skwd";
              template = "quickshell-colors.json";
              output = "~/.cache/skwd/colors.json";
            }
          ];
          components = {
            wallpaperSelector = {
              displayMode = "slices";
              sliceSpacing = -30;
              hexScrollStep = 1;
              customPresets = { };
            };
          };
          wallpaperMute = true;
          pickOnlyMode = false;
          externalWallpaperCommand = "";
          postProcessing = [ ];
          performance = {
            imageOptimizePreset = "balanced";
            imageOptimizeResolution = "2k";
            videoConvertPreset = "balanced";
            videoConvertResolution = "2k";
            autoOptimizeImages = false;
            autoConvertVideos = false;
            imageTrashDays = 7;
            videoTrashDays = 7;
            autoDeleteImageTrash = false;
            autoDeleteVideoTrash = false;
          };
          paper = {
            engine = "skwd-paper";
          };
        };
      };
    })
  ];
}
