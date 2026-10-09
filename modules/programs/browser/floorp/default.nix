{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.floorp = {
        enable = true;
        policies = import ./policies.nix { inherit lib; };
        languagePacks = [
          "en-GB"
          "en-US"
        ];
        profiles = {
          default = {
            # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
            settings = import ../settings.nix { inherit lib; };
            bookmarks = import ../bookmarks.nix;
            search = import ./search.nix { inherit pkgs; };
            # userChrome = builtins.readFile ./userChrome.css;
            # userContent = builtins.readFile ./userContent.css;
            extraConfig = ''
              ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
              ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}

              // floorp
              user_pref("floorp.panelSidebar.enabled", false);
              user_pref("floorp.tabsleep.enabled", true);
              user_pref("floorp.tabsleep.tabTimeoutMinutes", 30);
              user_pref("floorp.browser.sidebar.is.displayed", false);
              user_pref("floorp.browser.tabs.verticaltab", true);
              user_pref("floorp.browser.tabbar.settings", 0);
              user_pref("floorp.tabbar.style", 0);
              user_pref("floorp.browser.sidebar.enable", false);
              user_pref("floorp.browser.sidebar.right", false);
              user_pref("floorp.extensions.allowPrivateBrowsingByDefault.is.enabled", true);
              user_pref("floorp.Tree-type.verticaltab.optimization", true);
              user_pref("floorp.verticaltab.hover.enabled", true);
              user_pref("browser.newtabpage.activity-stream.floorp.background.type", 0); // 0 = none, 1 = random, 3 = folder, 4 = custom
              user_pref("browser.newtabpage.activity-stream.floorp.newtab.imagecredit.hide", true);
              user_pref("browser.newtabpage.activity-stream.floorp.newtab.releasenote.hide", true);
            '';
          };
        };
      };
    })
  ];
}
