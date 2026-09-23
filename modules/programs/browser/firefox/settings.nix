{ lib, ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  extensions = import ../extensions.nix { inherit lib; };
in
{
  # appearance & ui
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "svg.context-properties.content.enabled" = true;
  "layout.css.color-mix.enabled" = true;
  "layout.css.backdrop-filter.enabled" = true;
  "layout.word_select.eat_space_to_next_word" = lock-false;
  "browser.tabs.delayHidingAudioPlayingIconMS" = 0;
  "browser.tabs.inTitlebar" = 0;
  "browser.tabs.firefox-view" = lock-false;
  "browser.toolbars.bookmarks.visibility" = "newtab"; # always, never, newtab
  "browser.newtab.url" = "about:blank";
  "browser.newtabpage.introShown" = lock-true;
  "browser.newtabpage.pinned" = false;
  "browser.newtabpage.enhanced" = lock-false;
  "browser.protections_panel.infoMessage.seen" = lock-true;
  "trailhead.firstrun.didSeeAboutWelcome" = lock-true;
  "browser.aboutwelcome.enabled" = lock-false;
  "browser.aboutConfig.showWarning" = lock-false;

  # scrolling
  "general.smoothScroll" = true;
  "general.smoothScroll.lines.durationMaxMS" = 125;
  "general.smoothScroll.lines.durationMinMS" = 125;
  "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
  "general.smoothScroll.mouseWheel.durationMinMS" = 100;
  "general.smoothScroll.msdPhysics.enabled" = true;
  "general.smoothScroll.other.durationMaxMS" = 125;
  "general.smoothScroll.other.durationMinMS" = 125;
  "general.smoothScroll.pages.durationMaxMS" = 125;
  "general.smoothScroll.pages.durationMinMS" = 125;
  "mousewheel.min_line_scroll_amount" = 30;
  "mousewheel.system_scroll_override_on_root_content.enabled" = true;
  "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
  "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
  "toolkit.scrollbox.horizontalScrollDistance" = 6;
  "toolkit.scrollbox.verticalScrollDistance" = 2;

  # dns & network
  "network.trr.mode" = 0;
  "network.trr.custom_uri" = "https://dns.quad9.net/dns-query";
  "network.trr.uri" = "https://dns.quad9.net/dns-query";
  "network.file.disable_unc_paths" = lock-true;
  "network.gio.supported-protocols" = "";
  "network.proxy.socks_remote_dns" = lock-true;

  # prefetch & connections
  "network.prefetch-next" = lock-false;
  "network.dns.disablePrefetch" = lock-true;
  "network.dns.disablePrefetchFromHTTPS" = lock-true;
  "network.http.speculative-parallel-limit" = 0;
  "browser.places.speculativeConnect.enabled" = lock-false;
  "browser.urlbar.speculativeConnect.enabled" = lock-false;

  # tracking & fingerprinting
  "privacy.purge_trackers.enabled" = lock-true;
  "privacy.trackingprotection.enabled" = lock-true;
  "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
  "privacy.resistFingerprinting" = lock-true;
  "privacy.trackingprotection.socialtracking.enabled" = lock-true;
  "privacy.trackingprotection.cryptomining.enabled" = lock-true;
  "privacy.globalprivacycontrol.enabled" = lock-true;
  "privacy.globalprivacycontrol.functionality.enabled" = lock-true;
  "privacy.donottrackheader.enabled" = lock-true;
  "privacy.donottrackheader.value" = 1;
  "privacy.query_stripping.enabled" = lock-true;
  "privacy.query_stripping.enabled.pbmode" = lock-true;
  "browser.contentblocking.category" = {
    Value = "strict";
    Status = "locked";
  };
  "network.http.referer.XOriginTrimmingPolicy" = 2;
  "network.http.referer.spoofSource" = lock-false;
  "privacy.antitracking.isolateContentScriptResources" = lock-true;

  # shutdown & sanitizing
  "privacy.sanitize.sanitizeOnShutdown" = lock-true;
  "privacy.clearOnShutdown.cache" = lock-true;
  "privacy.clearOnShutdown.cookies" = lock-true;
  "privacy.clearOnShutdown.downloads" = lock-true;
  "privacy.clearOnShutdown.formdata" = lock-true;
  "privacy.clearOnShutdown.history" = lock-true;
  "privacy.clearOnShutdown.offlineApps" = lock-true;
  "privacy.clearOnShutdown.sessions" = lock-true;
  "privacy.clearOnShutdown.siteSettings" = lock-true;
  "privacy.clearOnShutdown_v2.cache" = lock-true;
  # "privacy.clearOnShutdown_v2.cookies" = lock-true;
  "privacy.clearOnShutdown_v2.downloads" = lock-true;
  "privacy.clearOnShutdown_v2.formdata" = lock-true;
  "privacy.clearOnShutdown_v2.history" = lock-true;
  # "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = lock-true;
  "privacy.clearOnShutdown_v2.offlineApps" = lock-true;
  "privacy.clearOnShutdown_v2.sessions" = lock-true;
  "privacy.clearOnShutdown_v2.siteSettings" = lock-true;

  # telemetry
  "toolkit.telemetry.enabled" = lock-false;
  "toolkit.telemetry.unified" = lock-false;
  "toolkit.telemetry.server" = "data:,";
  "toolkit.telemetry.archive.enabled" = lock-false;
  "toolkit.telemetry.newProfilePing.enabled" = lock-false;
  "toolkit.telemetry.shutdownPingSender.enabled" = lock-false;
  "toolkit.telemetry.updatePing.enabled" = lock-false;
  "toolkit.telemetry.bhrPing.enabled" = lock-false;
  "toolkit.telemetry.firstShutdownPing.enabled" = lock-false;
  "toolkit.telemetry.coverage.opt-out" = lock-true;
  "toolkit.coverage.opt-out" = lock-true;
  "toolkit.coverage.endpoint.base" = "";
  "browser.newtabpage.activity-stream.telemetry" = lock-false;
  "browser.newtabpage.activity-stream.feeds.telemetry" = lock-false;
  "browser.ping-centre.telemetry" = lock-false;
  "datareporting.healthreport.uploadEnabled" = lock-false;
  "datareporting.healthreport.service.enabled" = lock-false;
  "datareporting.policy.dataSubmissionEnabled" = lock-false;
  "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
  "app.shield.optoutstudies.enabled" = lock-false;
  "app.normandy.enabled" = lock-false;
  "app.normandy.api_url" = "";
  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = lock-false;
  "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
  "experiments.supported" = lock-false;
  "experiments.enabled" = lock-false;
  "experiments.manifest.uri" = "";
  "captivedetect.canonicalURL" = "";
  "network.captive-portal-service.enabled" = lock-false;
  "network.connectivity-service.enabled" = lock-false;
  "geo.provider.use_geoclue" = lock-false;
  "extensions.webcompat-reporter.enabled" = lock-false;
  "browser.uitour.enabled" = lock-false;

  # security & tls
  "security.ssl.require_safe_negotiation" = lock-true;
  "security.ssl.treat_unsafe_negotiation_as_broken" = lock-true;
  "security.tls.enable_0rtt_data" = lock-false;
  "security.tls.version.enable-deprecated" = lock-false;
  "security.cert_pinning.enforcement_level" = {
    Value = 2;
    Status = "locked";
  };
  "security.remote_settings.crlite_filters.enabled" = lock-true;
  "security.pki.crlite_mode" = {
    Value = 2;
    Status = "locked";
  };
  "dom.security.https_only_mode" = lock-true;
  "dom.security.https_only_mode_ever_enabled" = lock-true;
  "dom.security.https_only_mode_send_http_background_request" = lock-false;
  "browser.xul.error_pages.expert_bad_cert" = lock-true;
  "network.auth.subresource-http-auth-allow" = 1;
  "network.IDN_show_punycode" = lock-true;
  "pdfjs.disabled" = false;
  "pdfjs.enableScripting" = lock-false;
  "dom.disable_window_move_resize" = lock-true;
  "security.dialog_enable_delay" = 1000;
  "permissions.manager.defaultsUrl" = "";
  "security.csp.reporting.enabled" = lock-false;
  "browser.contentanalysis.enabled" = lock-false;
  "browser.contentanalysis.default_result" = 0;
  "devtools.debugger.remote-enabled" = lock-false;

  # search & urlbar
  "browser.search.suggest.enabled" = lock-false;
  "browser.search.suggest.enabled.private" = lock-false;
  "browser.search.update" = false;
  "browser.urlbar.suggest.searches" = lock-false;
  "browser.urlbar.suggest.topsites" = lock-false;
  "browser.urlbar.suggest.openpage" = lock-false;
  "browser.urlbar.suggest.recentsearches" = lock-false;
  "browser.urlbar.quicksuggest.enabled" = lock-false;
  "browser.urlbar.suggest.quicksuggest.nonsponsored" = lock-false;
  "browser.urlbar.suggest.quicksuggest.sponsored" = lock-false;
  "browser.urlbar.trending.featureGate" = lock-false;
  "browser.urlbar.addons.featureGate" = lock-false;
  "browser.urlbar.amp.featureGate" = lock-false;
  "browser.urlbar.importantDates.featureGate" = lock-false;
  "browser.urlbar.market.featureGate" = lock-false;
  "browser.urlbar.mdn.featureGate" = lock-false;
  "browser.urlbar.weather.featureGate" = lock-false;
  "browser.urlbar.wikipedia.featureGate" = lock-false;
  "browser.urlbar.yelp.featureGate" = lock-false;
  "browser.urlbar.yelpRealtime.featureGate" = lock-false;
  "browser.urlbar.showSearchTerms.enabled" = lock-false;
  "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
  "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
  "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";

  # passwords & autofill
  "signon.rememberSignons" = lock-false;
  "signon.autofillForms" = lock-false;
  "signon.formlessCapture.enabled" = lock-false;
  "security.webauthn.always_allow_direct_attestation" = lock-false;
  "browser.formfill.enable" = lock-false;
  "extensions.formautofill.addresses.enabled" = lock-false;
  "extensions.formautofill.available" = "off";
  "extensions.formautofill.creditCards.available" = lock-false;
  "extensions.formautofill.creditCards.enabled" = lock-false;
  "extensions.formautofill.heuristics.enabled" = lock-false;

  # downloads
  "browser.download.useDownloadDir" = false;
  "browser.download.alwaysOpenPanel" = lock-false;
  "browser.download.manager.addToRecentDocs" = lock-false;
  "browser.download.always_ask_before_handling_new_types" = lock-true;
  "browser.helperApps.deleteTempFileOnExit" = lock-true;

  # media & webrtc
  "browser.privatebrowsing.forceMediaMemoryCache" = lock-true;
  "media.peerconnection.ice.proxy_only_if_behind_proxy" = lock-true;
  "media.peerconnection.ice.default_address_only" = lock-true;
  "plugin.state.flash" = 0;
  "plugins.enumerable_names" = "";

  # containers
  "privacy.userContext.enabled" = true;
  "privacy.userContext.ui.enabled" = true;
  "privacy.userContext.longPressBehavior" = 2;

  # permissions
  "permissions.default.geo" = 2;
  "permissions.default.camera" = 2;
  "permissions.default.microphone" = 0;
  "permissions.default.desktop-notification" = 2;
  "permissions.default.xr" = 2;
  "privacy.popups.disable_from_plugins" = 3;
  "dom.block_multiple_popups" = lock-true;
  "dom.webnotifications.enabled" = lock-false;
  "dom.webnotifications.serviceworker.enabled" = lock-false;
  "browser.tabs.searchclipboardfor.middleclick" = lock-false;

  # new tab & activity stream
  "browser.newtabpage.activity-stream.enabled" = lock-false;
  "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
  "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
  "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
  "browser.newtabpage.activity-stream.feeds.snippets" = false;
  "browser.newtabpage.activity-stream.showSponsored" = lock-false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

  # extensions
  "extensions.enabledScopes" = {
    Value = 5;
    Status = "locked";
  };
  "extensions.autoDisableScopes" = {
    Value = 0;
    Status = "locked";
  };
  "extensions.postDownloadThirdPartyPrompt" = lock-false;
  "extensions.allowPrivateBrowsingByDefault" = lock-true;
  "extensions.webextensions.restrictedDomains" = {
    Value = "";
    Status = "locked";
  };
  "extensions.blocklist.enabled" = lock-true;
  "extensions.quarantinedDomains.enabled" = lock-true;
  "extensions.pocket.enabled" = lock-false;
  "extensions.screenshots.disabled" = lock-true;
  "extensions.getAddons.showPane" = lock-false;
  "extensions.getAddons.cache.enabled" = lock-false;
  "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
  "extensions.extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
  "extensions.ui.sitepermission.hidden" = lock-true;
  "extensions.ui.locale.hidden" = lock-true;
  "extensions.webcompat.enable_picture_in_picture_overrides" = true;
  "extensions.webcompat.enable_shims" = true;
  "extensions.webcompat.perform_injections" = true;
  "extensions.webcompat.perform_ua_overrides" = true;

  # general
  "ui.key.accelKey" = 17;
  "intl.locale.requested" = "en-GB,en-US";
  "browser.startup.page" = 3;
  "browser.startup.homepage" = "";
  "browser.startup.homepage_override.mstone" = "ignore";
  "browser.bookmarks.defaultLocation" = "toolbar";
  "browser.bookmarks.restore_default_bookmarks" = false;
  "browser.ctrlTab.recentlyUsedOrder" = false;
  "browser.shell.checkDefaultBrowser" = lock-false;
  "browser.discovery.enabled" = false;
  "browser.laterrun.enabled" = false;
  "browser.ssb.enabled" = true;
  "identity.fxaccounts.enabled" = lock-false;
  "app.update.auto" = false;

  # ui customization
  "browser.uiCustomization.state" = builtins.toJSON {
    currentVersion = 20;
    newElementCount = 7;
    placements = {
      widget-overflow-fixed-list = [ ];
      unified-extensions-area = extensions.unified-extensions-area;
      nav-bar = [
        "back-button"
        "forward-button"
        "stop-reload-button"
        "urlbar-container"
        # "developer-button"
        "downloads-button"
        "unified-extensions-button"
      ]
      ++ extensions.nav-bar;
      toolbar-menubar = [ "menubar-items" ];
      TabsToolbar = [
        "firefox-view-button"
        "tabbrowser-tabs"
        "new-tab-button"
        "alltabs-button"
      ];
      PersonalToolbar = [
        "personal-bookmarks"
        "managed-bookmarks"
      ];
    };
  };
}
