{
  username,
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
  home-manager.users.${username} = _: {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
          extraPolicies = {
            DisableTelemetry = true;
            # add policies here...

            /*
            ---- GLOBAL EXTENSIONS ----
            */
            ExtensionSettings = {
              "*".installation_mode = "normal_installed"; # blocks all addons except the ones specified below
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
              # "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
              #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
              #   installation_mode = "force_installed";
              # };
              "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
                installation_mode = "normal_installed";
              };
              "queryamoid@kaply.com" = {
                install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.1/query_amo_addon_id-0.1-fx.xpi";
                installation_mode = "force_installed";
              };
              # add extensions here...
            };

            /*
            ---- PREFERENCES ----
            */
            # Set preferences shared by all profiles.
            Preferences = {
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

              # Block more unwanted stuff
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
              "toolkit.telemetry.unified" = lock-false;
              "toolkit.telemetry.enabled" = lock-false;
              "toolkit.telemetry.server" = "data:,";
              "toolkit.telemetry.archive.enabled" = lock-false;
              "toolkit.telemetry.coverage.opt-out" = lock-true;
              "toolkit.coverage.opt-out" = lock-true;
              "toolkit.coverage.endpoint.base" = "";
              "experiments.supported" = lock-false;
              "experiments.enabled" = lock-false;
              "experiments.manifest.uri" = "";
              "browser.ping-centre.telemetry" = lock-false;
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
              "browser.newtab.url" = "about:blank";
              "browser.newtabpage.activity-stream.enabled" = lock-false;
              "browser.newtabpage.activity-stream.telemetry" = lock-false;
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
              "browser.toolbars.bookmarks.visibility" = "newtab";
              #"browser.urlbar.placeholderName" = "Google";
              "browser.urlbar.suggest.openpage" = false;
              "datareporting.policy.dataSubmissionEnable" = false;
              "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

              "extensions.screenshots.disabled" = lock-true;
              "extensions.getAddons.showPane" = lock-false;
              "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
              "extensions.extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
              # "extensions.update.enabled" = false;
              "extensions.webcompat.enable_picture_in_picture_overrides" = true;
              "extensions.webcompat.enable_shims" = true;
              "extensions.webcompat.perform_injections" = true;
              "extensions.webcompat.perform_ua_overrides" = true;
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
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              # profile-switcher
            ];
            bookmarks = [
              {
                name = "Bookmarks Toolbar";
                toolbar = true;
                bookmarks = [
                  {
                    name = "Youtube";
                    url = "https://www.youtube.com/";
                  }
                  {
                    name = "Github";
                    url = "https://github.com/";
                  }
                  {
                    name = "NixOS pkgs";
                    url = "https://search.nixos.org/packages";
                  }
                  {
                    name = "NixOS Wiki";
                    url = "https://nixos.wiki";
                  }
                  {
                    name = "NixOS Configs";
                    url = "https://nixos.wiki/wiki/Configuration_Collection";
                  }
                  {
                    name = "Search Engines";
                    bookmarks = [
                      {
                        name = "Startpage";
                        url = "https://www.startpage.com/do/mypage.pl?prfe=358f0310b1c47c53e468bbed228d921438352de61d9ea4fcad92c335685a8e4de5118de1f91f06960587d38d76310c444d27766f935be9bb7dfa8fbc7f0b8207fbcd0a23600e2f957b79e6b3";
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
              default = "Google";
              privateDefault = "Startpage";
              order = [
                "Startpage"
                "NixOS Packages"
                "NixOS Options"
                "NixOS Wiki"
                "Home Manager Options"
                "Searx"
                "Google"
              ];
              engines = {
                "Startpage" = {
                  urls = [
                    {
                      template = "https://www.startpage.com/sp/search?query={searchTerms}&prfe=dea8b8a2e1126185da987128a196ee5c47cdf324dce146f96b3b9157ab1f9e7166ae05d134c935eccc20f54e46222c8f1bb60faece00557b02e7a4e1fe397bc0f6750fbd3f7f580b241188&abp=-1";
                    }
                  ];
                  icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@sp"];
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
                "Searx" = {
                  urls = [{template = "https://searx.aicampground.com/?q={searchTerms}";}];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = ["@sx"];
                };
                "Bing".metaData.hidden = true;
                "Ebay".metaData.hidden = true;
                "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
              };
            };
            extraConfig = ''
              lockPref("extensions.autoDisableScopes", 0);
            '';
          };
          # add profiles here...
        };
      };
    };
  };
}
