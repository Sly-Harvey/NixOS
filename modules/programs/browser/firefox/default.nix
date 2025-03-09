{
  lib,
  pkgs,
  ...
}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  home-manager.sharedModules = [
    (_: {
      programs = {
        firefox = {
          enable = true;
          package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
            extraPolicies = {
              DisableTelemetry = true;
              DisablePocket = true;
              DisableFirefoxAccounts = true;
              DisableFeedbackCommands = true;
              DisableFirefoxStudies = true;
              OfferToSaveLogins = false;
              OffertosaveloginsDefault = false;
              PasswordManagerEnabled = false;
              EncryptedMediaExtensions.Enabled = true;
              OverrideFirstRunPage = "";
              OverridePostUpdatePage = "";
              EnableTrackingProtection = {
                Value = true;
                Cryptomining = true;
                Fingerprinting = true;
                EmailTracking = true;
              };
              UserMessaging = {
                ExtensionRecommendations = false;
                FeatureRecommendations = false;
                MoreFromMozilla = false;
                SkipOnboarding = true;
                WhatsNew = false;
              };
              # SanitizeOnShutdown = {
              #   Cache = true;
              #   Cookies = false;
              #   Downloads = true;
              #   FormData = true;
              #   History = false;
              #   Sessions = false;
              #   SiteSettings = false;
              #   OfflineApps = true;
              #   Locked = true;
              # };

              "3rdparty".Extensions = {
                "addon@darkreader.org" = {
                  enabled = true;
                  automation = {
                    enabled = true;
                    behavior = "OnOff";
                    mode = "system";
                  };
                  detectDarkTheme = true;
                  enabledByDefault = true;
                  changeBrowserTheme = false;
                  enableForProtectedPages = true;
                  fetchNews = false;
                  previewNewDesign = true;
                };
                "uBlock0@raymondhill.net" = {
                  advancedSettings = [
                    [
                      "userResourcesLocation"
                      "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/video-swap-new/video-swap-new-ublock-origin.js"
                    ]
                  ];
                  adminSettings = {
                    userFilters = lib.concatMapStrings (x: x + "\n") [
                      "twitch.tv##+js(twitch-videoad)"
                      "||1337x.vpnonly.site"
                    ];
                    userSettings = rec {
                      uiTheme = "dark";
                      uiAccentCustom = true;
                      uiAccentCustom0 = "#CA9EE6";
                      cloudStorageEnabled = lib.mkForce false; # Security liability?
                      advancedUserEnabled = true;
                      userFiltersTrusted = true;
                      importedLists = [
                        "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
                        "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
                        "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/BrowseWebsitesWithoutLoggingIn.txt"
                        "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs for uBo/clear_urls_uboified.txt"
                        "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Dandelion Sprout's Anti-Malware List.txt"
                        "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
                        "https://raw.githubusercontent.com/OsborneLabs/Columbia/master/Columbia.txt"
                        "https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt?_=rawlist"
                        "https://raw.githubusercontent.com/iam-py-test/my_filters_001/main/antimalware.txt"
                        "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
                        "https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt"
                        "https://raw.githubusercontent.com/yokoffing/filterlists/main/privacy_essentials.txt"
                      ];
                      externalLists = lib.concatStringsSep "\n" importedLists;
                      popupPanelSections = 31;
                    };
                    selectedFilterLists = [
                      "ublock-filters"
                      "ublock-badware"
                      "ublock-privacy"
                      "ublock-quick-fixes"
                      "ublock-unbreak"
                      "easylist"
                      "adguard-generic"
                      "adguard-mobile"
                      "easyprivacy"
                      "adguard-spyware"
                      "adguard-spyware-url"
                      "block-lan"
                      "urlhaus-1"
                      "curben-phishing"
                      "plowe-0"
                      "dpollock-0"
                      "fanboy-cookiemonster"
                      "ublock-cookies-easylist"
                      "adguard-cookies"
                      "ublock-cookies-adguard"
                      "fanboy-social"
                      "adguard-social"
                      "fanboy-thirdparty_social"
                      "easylist-chat"
                      "easylist-newsletters"
                      "easylist-notifications"
                      "easylist-annoyances"
                      "adguard-mobile-app-banners"
                      "adguard-other-annoyances"
                      "adguard-popup-overlays"
                      "adguard-widgets"
                      "ublock-annoyances"
                      "DEU-0"
                      "FRA-0"
                      "NLD-0"
                      "RUS-0"
                      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
                      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/BrowseWebsitesWithoutLoggingIn.txt"
                      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Dandelion Sprout's Anti-Malware List.txt"
                      "https://raw.githubusercontent.com/yokoffing/filterlists/main/privacy_essentials.txt"
                      "https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt"
                      "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
                      "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
                      "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
                      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs for uBo/clear_urls_uboified.txt"
                      "https://raw.githubusercontent.com/iam-py-test/my_filters_001/main/antimalware.txt"
                      "https://raw.githubusercontent.com/OsborneLabs/Columbia/master/Columbia.txt"
                      "https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt?_=rawlist"
                      "user-filters"
                    ];
                  };
                };
              };

              /*
              ---- PREFERENCES ----
              */
              # Set preferences shared by all profiles.
              Preferences = {
                # enable custom userchrome
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "svg.context-properties.content.enabled" = true;
                "layout.css.color-mix.enabled" = true;
                "browser.tabs.delayHidingAudioPlayingIconMS" = 0;
                "layout.css.backdrop-filter.enabled" = true;
                "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
                "privacy.userContext.enabled" = true;
                "privacy.userContext.ui.enabled" = true;
                "privacy.userContext.longPressBehavior" = 2;

                # Performance settings
                "gfx.webrender.all" = true; # Force enable GPU acceleration
                "media.ffmpeg.vaapi.enabled" = true;
                "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes
                "reader.parse-on-load.force-enabled" = true;
                "privacy.webrtc.legacyGlobalIndicator" = false;

                # Use cloudflare for better security/privacy
                "network.trr.mode" = 3; # 2 if your havng DNS problems
                "network.trr.custom_uri" = "https://cloudflare-dns.com/dns-query";
                "network.trr.uri" = "https://cloudflare-dns.com/dns-query";

                # Remove trackers
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

                # Clear on shutdown (Only locks the options to true. Manually enable in firefox settings)
                "privacy.sanitize.sanitizeOnShutdown" = lock-true;
                "privacy.clearOnShutdown.cache" = lock-true;
                "privacy.clearOnShutdown.cookies" = lock-true;
                "privacy.clearOnShutdown.downloads" = lock-true;
                "privacy.clearOnShutdown.formdata" = lock-true;
                "privacy.clearOnShutdown.history" = lock-true;
                "privacy.clearOnShutdown.offlineApps" = lock-true;
                "privacy.clearOnShutdown.sessions" = lock-true;
                "privacy.clearOnShutdown.siteSettings" = lock-true;

                # Block telemetry
                "toolkit.telemetry.enabled" = lock-false;
                "toolkit.telemetry.unified" = lock-false;
                "toolkit.telemetry.server" = "data:,";
                "toolkit.telemetry.archive.enabled" = lock-false;
                "toolkit.telemetry.newProfilePing.enabled" = lock-false;
                "toolkit.telemetry.shutdownPingSender.enabled" = lock-false;
                "toolkit.telemetry.updatePing.enabled" = lock-false;
                "toolkit.telemetry.bhrPing.enabled" = lock-false;
                "toolkit.telemetry.coverage.opt-out" = lock-true;
                "toolkit.telemetry.firstShutdownPing.enabled" = lock-false;
                "browser.newtabpage.activity-stream.telemetry" = lock-false;
                "browser.ping-centre.telemetry" = lock-false;

                # Permissions
                # 0=always ask (default), 1=allow, 2=block
                "permissions.default.geo" = 2;
                "permissions.default.camera" = 2;
                "permissions.default.microphone" = 0;
                "permissions.default.desktop-notification" = 2;
                "permissions.default.xr" = 2; # Virtual Reality

                # Block more unwanted stuff
                "dom.block_multiple_popups" = lock-true;
                "browser.privatebrowsing.forceMediaMemoryCache" = lock-true;
                "browser.contentblocking.category" = {
                  Value = "strict";
                  Status = "locked";
                };
                "browser.search.suggest.enabled" = lock-false;
                "browser.search.suggest.enabled.private" = lock-false;
                "privacy.popups.disable_from_plugins" = 3;
                "extensions.pocket.enabled" = lock-false;
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
                "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
                "browser.newtabpage.activity-stream.showSponsored" = lock-false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
                "layout.word_select.eat_space_to_next_word" = lock-false;
                "browser.shell.checkDefaultBrowser" = lock-false;
                "signon.rememberSignons" = lock-false;
                "toolkit.coverage.opt-out" = lock-true;
                "toolkit.coverage.endpoint.base" = "";
                "experiments.supported" = lock-false;
                "experiments.enabled" = lock-false;
                "experiments.manifest.uri" = "";
                "datareporting.healthreport.uploadEnabled" = lock-false;
                "datareporting.healthreport.service.enabled" = lock-false;
                "datareporting.policy.dataSubmissionEnabled" = lock-false;
                "breakpad.reportURL" = "";
                "browser.tabs.crashReporting.sendReport" = lock-false;
                "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
                "browser.formfill.enable" = lock-false;
                "extensions.formautofill.addresses.enabled" = lock-false;
                "extensions.formautofill.available" = "off";
                "extensions.formautofill.creditCards.available" = lock-false;
                "extensions.formautofill.creditCards.enabled" = lock-false;
                "extensions.formautofill.heuristics.enabled" = lock-false;
                "app.normandy.enabled" = lock-false;
                "app.normandy.api_url" = "";
                "dom.webnotifications.enabled" = lock-false;
                "dom.webnotifications.serviceworker.enabled" = lock-false;

                # General settings
                "ui.key.accelKey" = 17; # Set CTRL as master key
                "browser.aboutConfig.showWarning" = lock-false;
                "browser.aboutwelcome.enabled" = lock-false;
                "browser.tabs.firefox-view" = lock-false;
                "browser.startup.homepage_override.mstone" = "ignore";
                "trailhead.firstrun.didSeeAboutWelcome" = true; # Disable welcome splash
                "browser.newtab.url" = "about:blank";
                "browser.newtabpage.activity-stream.enabled" = lock-false;
                "browser.newtabpage.enhanced" = lock-false;
                "browser.newtabpage.introShown" = lock-true;
                "browser.newtabpage.pinned" = false;
                "browser.bookmarks.defaultLocation" = "toolbar";
                "browser.startup.page" = 3;
                "app.shield.optoutstudies.enabled" = lock-false;
                "dom.security.https_only_mode" = lock-true;
                "dom.security.https_only_mode_ever_enabled" = lock-true;
                "identity.fxaccounts.enabled" = lock-false;
                "app.update.auto" = false;
                "browser.startup.homepage" = "";
                "browser.bookmarks.restore_default_bookmarks" = false;
                "browser.ctrlTab.recentlyUsedOrder" = false;
                "browser.discovery.enabled" = false;
                "browser.laterrun.enabled" = false;
                "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
                "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
                "browser.newtabpage.activity-stream.feeds.snippets" = false;
                "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
                "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
                "browser.protections_panel.infoMessage.seen" = true;
                "browser.ssb.enabled" = true;
                "browser.toolbars.bookmarks.visibility" = "newtab"; # always, never, newtab
                #"browser.urlbar.placeholderName" = "Google";
                "browser.urlbar.suggest.openpage" = false;
                "datareporting.policy.dataSubmissionEnable" = false;
                "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

                "extensions.screenshots.disabled" = lock-true;
                "extensions.getAddons.showPane" = lock-false;
                "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
                "extensions.extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
                # "extensions.update.enabled" = false;
                "extensions.webcompat.enable_picture_in_picture_overrides" = true;
                "extensions.webcompat.enable_shims" = true;
                "extensions.webcompat.perform_injections" = true;
                "extensions.webcompat.perform_ua_overrides" = true;

                "extensions.autoDisableScopes" = {
                  Value = 0;
                  Status = "locked";
                };
                "extensions.enabledScopes" = {
                  Value = 15;
                  Status = "locked";
                };
                "extensions.allowPrivateBrowsingByDefault" = lock-true;
                "extensions.webextensions.restrictedDomains" = {
                  Value = "";
                  Status = "locked";
                };

                # Do not tell what plugins we have enabled: https://mail.mozilla.org/pipermail/firefox-dev/2013-November/001186.html
                "plugins.enumerable_names" = "";
                "plugin.state.flash" = 0;
                "browser.search.update" = false;
                "extensions.getAddons.cache.enabled" = lock-false;
                "extensions.ui.sitepermission.hidden" = lock-true;
                "extensions.ui.locale.hidden" = lock-true;

                "browser.uiCustomization.state" = builtins.toJSON {
                  currentVersion = 20;
                  newElementCount = 7;
                  placements = {
                    widget-overflow-fixed-list = [];
                    unified-extensions-area = [
                      "ublock0_raymondhill_net-browser-action"
                      "firemonkey_eros_man-browser-action"
                      "addon_darkreader_org-browser-action"
                      "queryamoid_kaply_com-browser-action"
                      # "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
                    ];
                    nav-bar = [
                      "back-button"
                      "forward-button"
                      "stop-reload-button"
                      "urlbar-container"
                      # "developer-button"
                      "downloads-button"
                      "unified-extensions-button"

                      # Extensions
                      "ublock0_raymondhill_net-browser-action"
                      "firemonkey_eros_man-browser-action"
                      "addon_darkreader_org-browser-action"
                      # "queryamoid_kaply_com-browser-action"
                      # "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
                    ];
                    toolbar-menubar = ["menubar-items"];
                    TabsToolbar = [
                      "firefox-view-button"
                      "tabbrowser-tabs"
                      "new-tab-button"
                      "alltabs-button"
                    ];
                    PersonalToolbar = ["personal-bookmarks" "managed-bookmarks"];
                  };
                };
              };
            };
          };

          /*
          ---- PROFILES ----
          */
          # Switch profiles via about:profiles page.
          # For options that are available in Home-Manager see
          # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
          profiles = {
            default = {
              # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
              id = 0; # 0 is the default profile; see also option "isDefault"
              name = "default"; # name as listed in about:profiles
              isDefault = true; # can be omitted; true if profile ID is 0
              extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                ublock-origin
                violentmonkey
                darkreader
                betterttv
                sponsorblock
                return-youtube-dislikes
              ];
              settings = {};
              bookmarks = [
                {
                  name = "Bookmarks Toolbar";
                  toolbar = true;
                  bookmarks = [
                    {
                      name = "Youtube";
                      url = "https://www.youtube.com";
                    }
                    {
                      name = "Twitch";
                      url = "https://www.twitch.tv";
                    }
                    {
                      name = "Netflix";
                      url = "https://www.netflix.com";
                    }
                    {
                      name = "Github";
                      url = "https://github.com/";
                    }
                    {
                      name = "Lloyds Bank";
                      url = "https://www.lloydsbank.com/";
                    }
                    {
                      name = "NixOS";
                      bookmarks = [
                        {
                          name = "Search NixOS";
                          url = "https://mynixos.com/";
                        }
                        {
                          name = "NixOS Wiki";
                          url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
                        }
                        {
                          name = "NixOS Packages";
                          url = "https://search.nixos.org/packages";
                        }
                        {
                          name = "NixOS Options";
                          url = "https://search.nixos.org/options";
                        }
                        {
                          name = "NixOS Configs";
                          url = "https://wiki.nixos.org/wiki/Configuration_Collection";
                        }
                        {
                          name = "Nix Docs";
                          url = "https://noogle.dev/";
                        }
                        {
                          name = "Learn Nix";
                          url = "https://nix.dev/";
                        }
                      ];
                    }
                    {
                      name = "Search Engines";
                      bookmarks = [
                        {
                          name = "Startpage";
                          url = "https://www.startpage.com/do/mypage.pl?prfe=c602752472dd4a3d8286a7ce441403da08e5c4656092384ed3091a946a5a4a4c99962d0935b509f2866ff1fdeaa3c33a007d4d26e89149869f2f7d0bdfdb1b51aa7ae7f5f17ff4a233ff313d";
                        }
                        {
                          name = "SearX";
                          url = "https://searx.aicampground.com";
                        }
                      ];
                    }
                  ];
                }
              ];
              search = {
                force = true;
                default = "Startpage";
                privateDefault = "Startpage";
                order = [
                  "Startpage"
                  "Searx"
                  "Brave"
                  "NixOS Packages"
                  "NixOS Options"
                  "NixOS Wiki"
                  "Home Manager Options"
                  "Google"
                ];
                engines = {
                  "Startpage" = {
                    urls = [
                      {
                        template = "https://www.startpage.com/sp/search?query={searchTerms}&prfe=c602752472dd4a3d8286a7ce441403da08e5c4656092384ed3091a946a5a4a4c99962d0935b509f2866ff1fdeaa3c33a007d4d26e89149869f2f7d0bdfdb1b51aa7ae7f5f17ff4a233ff313d";
                      }
                    ];
                    icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = ["@sp"];
                  };
                  "Brave" = {
                    urls = [
                      {
                        template = "https://search.brave.com/search";
                        params = [
                          {
                            name = "q";
                            value = "{searchTerms}";
                          }
                        ];
                      }
                    ];
                    definedAliases = ["@br"];
                  };
                  "Searx" = {
                    urls = [{template = "https://searx.aicampground.com/?q={searchTerms}";}];
                    iconUpdateURL = "https://nixos.wiki/favicon.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = ["@sx"];
                  };
                  "NixOS Packages" = {
                    urls = [
                      {
                        template = "https://search.nixos.org/packages";
                        params = [
                          {
                            name = "type";
                            value = "packages";
                          }
                          {
                            name = "query";
                            value = "{searchTerms}";
                          }
                        ];
                      }
                    ];
                    icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = ["@np"];
                  };
                  "NixOS Options" = {
                    urls = [
                      {
                        template = "https://search.nixos.org/options";
                        params = [
                          {
                            name = "type";
                            value = "packages";
                          }
                          {
                            name = "query";
                            value = "{searchTerms}";
                          }
                        ];
                      }
                    ];
                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = ["@no"];
                  };
                  "NixOS Wiki" = {
                    urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                    iconUpdateURL = "https://nixos.wiki/favicon.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = ["@nw"];
                  };
                  "Home Manager Options" = {
                    urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}";}];
                    # urls = [
                    #   {
                    #     template = "https://mipmip.github.io/home-manager-option-search";
                    #     params = [
                    #       {
                    #         name = "query";
                    #         value = "{searchTerms}";
                    #       }
                    #     ];
                    #   }
                    # ];
                    iconUpdateURL = "https://avatars.githubusercontent.com/u/33221035";
                    updateInterval = 24 * 60 * 60 * 1000; # Update every day.
                    definedAliases = ["@hm"];
                  };
                  "Bing".metaData.hidden = true;
                  "Ebay".metaData.hidden = true;
                  "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
                };
              };
              # userChrome = ''
              # '';
              # userContent = ''
              # '';
            };
          };
        };
      };
    })
  ];
}
