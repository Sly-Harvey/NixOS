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
            settings = import ./settings.nix;
            bookmarks = import ./bookmarks.nix;
            search = import ./search.nix { inherit pkgs; };
            # userChrome = builtins.readFile ./userChrome.css;
            # userContent = builtins.readFile ./userContent.css;
            extraConfig = ''
              ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
              ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
              lockPref("extensions.activeThemeID", "{8446b178-c865-4f5c-8ccc-1d7887811ae3}");
              lockPref("extensions.formautofill.addresses.enabled", false);
              lockPref("extensions.formautofill.creditCards.enabled", false);
              lockPref("dom.security.https_only_mode_pbm", true);
              lockPref("dom.security.https_only_mode_error_page_user_suggestions", true);
              lockPref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
              lockPref("identity.fxaccounts.enabled", false);
              lockPref("browser.tabs.firefox-view-next", false);
              lockPref("privacy.sanitize.sanitizeOnShutdown", false);
              lockPref("privacy.clearOnShutdown.cache", true);
              lockPref("privacy.clearOnShutdown.cookies", false);
              lockPref("privacy.clearOnShutdown.offlineApps", false);
              lockPref("browser.sessionstore.privacy_level", 0);
              lockPref("floorp.browser.sidebar.enable", false);
              lockPref("geo.enabled", false);
              lockPref("media.navigator.enabled", false);
              lockPref("dom.event.clipboardevents.enabled", false);
              lockPref("dom.event.contextmenu.enabled", false);
              lockPref("dom.battery.enabled", false);
              lockPref("extensions.enabledScopes", 15);
              lockPref("extensions.autoDisableScopes", 0);
              lockPref("browser.newtabpage.activity-stream.floorp.newtab.imagecredit.hide", true);
              lockPref("browser.newtabpage.activity-stream.floorp.newtab.releasenote.hide", true);
              lockPref("browser.search.separatePrivateDefault", true);
            '';
          };
        };
      };
    })
  ];
}
