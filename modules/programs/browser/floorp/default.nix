{
  betterfox,
  lib,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    (_: {
      programs.floorp = {
        enable = true;
        policies = import ./policies.nix {inherit lib;};
        profiles = {
          default = {
            # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
            settings = import ./settings.nix;
            bookmarks = import ./bookmarks.nix;
            search = import ./search.nix {inherit pkgs;};
            extraConfig = ''
              ${builtins.readFile "${betterfox}/Fastfox.js"}
              ${builtins.readFile "${betterfox}/Peskyfox.js"}
              ${builtins.readFile "${betterfox}/Securefox.js"}
              ${builtins.readFile "${betterfox}/Smoothfox.js"}
              user_pref("extensions.formautofill.addresses.enabled", false);
              user_pref("extensions.formautofill.creditCards.enabled", false);
              user_pref("dom.security.https_only_mode_pbm", true);
              user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);
              user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
              user_pref("identity.fxaccounts.enabled", false);
              user_pref("browser.tabs.firefox-view-next", false);
              user_pref("privacy.sanitize.sanitizeOnShutdown", false);
              user_pref("privacy.clearOnShutdown.cache", true);
              user_pref("privacy.clearOnShutdown.cookies", false);
              user_pref("privacy.clearOnShutdown.offlineApps", false);
              user_pref("browser.sessionstore.privacy_level", 0);
              user_pref("floorp.browser.sidebar.enable", false);
              user_pref("geo.enabled", false);
              user_pref("media.navigator.enabled", false);
              user_pref("dom.event.clipboardevents.enabled", false);
              user_pref("dom.event.contextmenu.enabled", false);
              user_pref("dom.battery.enabled", false);
              user_pref("extensions.enabledScopes", 15);
              user_pref("extensions.autoDisableScopes", 0);
            '';
            # userChrome = ''
            # '';
            # userContent = ''
            # '';
          };
        };
      };
    })
  ];
}
