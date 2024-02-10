{ config, pkgs, ... }:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  lock-empty-string = {
    Value = "";
    Status = "locked";
  };
in {
    programs.firefox = {
    enable = true;

    policies = {
      DontCheckDefaultBrowser = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableAccounts = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      SearchBar = "unified";

      Preferences = {
        # Performance settings
        "gfx.webrender.all" = lock-true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = lock-true;
        "widget.dmabuf.force-enabled" = lock-true; # Required in recent Firefoxes

        # Re-bind ctrl to super (would interfere with tridactyl otherwise)
        "ui.key.accelKey" = 91;

        # Keep the reader button enabled at all times; really don't
        # care if it doesn't work 20% of the time, most websites are
        # crap and unreadable without this
        "reader.parse-on-load.force-enabled" = lock-true;

        # Hide the "sharing indicator", it's especially annoying
        # with tiling WMs on wayland
        "privacy.webrtc.legacyGlobalIndicator" = lock-false;

        # Actual settings
        "app.update.auto" = lock-false;
        "browser.bookmarks.restore_default_bookmarks" = lock-false;
        
        "browser.ctrlTab.recentlyUsedOrder" = lock-false;
        "browser.discovery.enabled" = lock-false;
        "browser.laterrun.enabled" = lock-false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = lock-false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        
        "browser.newtabpage.pinned" = lock-false;
        "browser.protections_panel.infoMessage.seen" = lock-true;
        "browser.quitShortcut.disabled" = lock-true;
        
        "browser.ssb.enabled" = lock-true;
        #"browser.toolbars.bookmarks.visibility" = "never";
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.urlbar.suggest.openpage" = lock-false;
        "datareporting.policy.dataSubmissionEnable" = lock-false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        
        "extensions.getAddons.showPane" = lock-false;
        "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
        "extensions.extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
        "extensions.update.enabled" = lock-false;
        "extensions.webcompat.enable_picture_in_picture_overrides" = lock-true;
        "extensions.webcompat.enable_shims" = lock-true;
        "extensions.webcompat.perform_injections" = lock-true;
        "extensions.webcompat.perform_ua_overrides" = lock-true;

        "network.trr.mode" = 3; # If not working then use 2
        "network.trr.custom_uri" = "https://cloudflare-dns.com/dns-query";
        "network.trr.uri" = "https://cloudflare-dns.com/dns-query";

        "signon.rememberSignons" = lock-true;
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "app.shield.optoutstudies.enabled" = lock-false;
        "browser.shell.checkDefaultBrowser" = lock-false;
        "dom.security.https_only_mode" = lock-true;
        "dom.security.https_only_mode_ever_enabled" = lock-true;
        "identity.fxaccounts.enabled" = lock-false;
        "privacy.trackingprotection.enabled" = lock-true;
        "privacy.trackingprotection.socialtracking.enabled" = lock-true;
        "privacy.donottrackheader.enabled" = lock-true;
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        "queryamoid@kaply.com" = {
          install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.1/query_amo_addon_id-0.1-fx.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}