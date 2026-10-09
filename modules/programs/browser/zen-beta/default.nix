{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # environment.systemPackages = with pkgs; [inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default];
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;
        policies = import ./policies.nix { inherit lib; };
        languagePacks = [
          "en-GB"
          "en-US"
        ];
        profiles = {
          default = {
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
            settings = import ../settings.nix { inherit lib; };
            bookmarks = import ../bookmarks.nix;
            search = import ./search.nix { inherit pkgs; };
            userChrome = builtins.readFile ./userChrome.css;
            userContent = builtins.readFile ./userContent.css;
            keyboardShortcuts = import ./keybinds.nix;
            keyboardShortcutsVersion = 21;
            mods = [
              "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" # Better Active Tabs
              "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
              "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
              "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
            ];
            extraConfig = ''
              ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
              ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}

              // zen
              user_pref("zen.view.use-single-toolbar", false);
              user_pref("zen.view.sidebar-expanded", false);
              user_pref("zen.view.compact.hide-toolbar", true);
              user_pref("zen.view.compact.hide-tabbar", true);
              user_pref("zen.watermark.enabled", false);
              user_pref("zen.welcome-screen.seen", true);
              user_pref("zen.view.show-newtab-button-top", false);
            '';
          };
        };
      };
    })
  ];
}
