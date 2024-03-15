{
  home-manager,
  username,
  pkgs,
  inputs,
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
            ---- EXTENSIONS ----
            */
            ExtensionSettings = {
              "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
              # uBlock Origin:
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
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
              "browser.contentblocking.category" = {
                Value = "strict";
                Status = "locked";
              };
              "extensions.pocket.enabled" = lock-false;
              "extensions.screenshots.disabled" = lock-true;
              # add global preferences here...
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
            extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
              ublock-origin
              privacy-badger
              darkreader
              profile-switcher
              vimium
            ];
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
                name = "Firefox addons";
                url = "https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json";
              }
            ];
            search = {
              force = true;
              default = "Google";
              order = ["Google" "Startpage" "Searx"];
              engines = {
                "Startpage" = {
                  urls = [
                    {
                      template = "https://www.startpage.com/sp/search?query={searchTerms}&prfe=dea8b8a2e1126185da987128a196ee5c47cdf324dce146f96b3b9157ab1f9e7166ae05d134c935eccc20f54e46222c8f1bb60faece00557b02e7a4e1fe397bc0f6750fbd3f7f580b241188&abp=-1";
                    }
                  ];
                  icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@startpage"];
                };
                "Nix Packages" = {
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
                "NixOS Wiki" = {
                  urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = ["@nw"];
                };
                "Searx" = {
                  urls = [{template = "https://searx.aicampground.com/?q={searchTerms}";}];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = ["@searx"];
                };
                "Bing".metaData.hidden = true;
                "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
              };
            };
            settings = {
              # Performance settings
              "gfx.webrender.all" = true; # Force enable GPU acceleration
              "media.ffmpeg.vaapi.enabled" = true;
              "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

              # Re-bind ctrl to super (would interfere with tridactyl otherwise)
              "ui.key.accelKey" = 91;

              # Keep the reader button enabled at all times; really don't
              # care if it doesn't work 20% of the time, most websites are
              # crap and unreadable without this
              "reader.parse-on-load.force-enabled" = true;

              # Hide the "sharing indicator", it's especially annoying
              # with tiling WMs on wayland
              "privacy.webrtc.legacyGlobalIndicator" = false;

              # Actual settings
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
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;

              "browser.newtabpage.pinned" = false;
              "browser.protections_panel.infoMessage.seen" = true;
              "browser.quitShortcut.disabled" = true;

              "browser.ssb.enabled" = true;
              "browser.toolbars.bookmarks.visibility" = "newtab";
              #"browser.urlbar.placeholderName" = "Google";
              "browser.urlbar.suggest.openpage" = false;
              "datareporting.policy.dataSubmissionEnable" = false;
              "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

              "extensions.getAddons.showPane" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "extensions.extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
              "extensions.update.enabled" = false;
              "extensions.webcompat.enable_picture_in_picture_overrides" = true;
              "extensions.webcompat.enable_shims" = true;
              "extensions.webcompat.perform_injections" = true;
              "extensions.webcompat.perform_ua_overrides" = true;

              "network.trr.mode" = 2;
              "network.trr.custom_uri" = "1.1.1.1";
              "network.trr.uri" = "1.1.1.1";

              "signon.rememberSignons" = false;
              "browser.startup.page" = 3;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "app.shield.optoutstudies.enabled" = false;
              "browser.contentblocking.category" = "strict";
              "browser.shell.checkDefaultBrowser" = false;
              "dom.security.https_only_mode" = true;
              "dom.security.https_only_mode_ever_enabled" = true;
              "identity.fxaccounts.enabled" = false;
              "privacy.trackingprotection.enabled" = true;
              "privacy.trackingprotection.socialtracking.enabled" = true;
              "privacy.donottrackheader.enabled" = true;
            };
            extraConfig = ''
              lockPref("extensions.autoDisableScopes", 0);
            '';
          };
          private = {
            id = 1;
            name = "private";
            isDefault = false;
            extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
              ublock-origin
              privacy-badger
              darkreader
              profile-switcher
              vimium
            ];
            bookmarks = [
              {
                name = "Youtube";
                url = "https://www.youtube.com/";
              }
              {
                name = "Twitch";
                url = "https://www.twitch.tv/";
              }
              {
                name = "Kick";
                url = "https://www.kick.com/";
              }
              {
                name = "Github";
                url = "https://github.com/";
              }
              {
                name = "Firefox addons";
                url = "https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json";
              }
            ];
            search = {
              force = true;
              default = "Startpage";
              order = ["Starpage" "Searx" "Google"];
              engines = {
                "Startpage" = {
                  urls = [
                    {
                      template = "https://www.startpage.com/sp/search?query={searchTerms}&prfe=dea8b8a2e1126185da987128a196ee5c47cdf324dce146f96b3b9157ab1f9e7166ae05d134c935eccc20f54e46222c8f1bb60faece00557b02e7a4e1fe397bc0f6750fbd3f7f580b241188&abp=-1";
                    }
                  ];
                  icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@startpage"];
                };
                "Nix Packages" = {
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
                "NixOS Wiki" = {
                  urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = ["@nw"];
                };
                "Searx" = {
                  urls = [{template = "https://searx.aicampground.com/?q={searchTerms}";}];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = ["@searx"];
                };
                "Bing".metaData.hidden = true;
                "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
              };
            };
            settings = {
              # Performance settings
              "gfx.webrender.all" = true; # Force enable GPU acceleration
              "media.ffmpeg.vaapi.enabled" = true;
              "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

              # Re-bind ctrl to super (would interfere with tridactyl otherwise)
              "ui.key.accelKey" = 91;

              # Keep the reader button enabled at all times; really don't
              # care if it doesn't work 20% of the time, most websites are
              # crap and unreadable without this
              "reader.parse-on-load.force-enabled" = true;

              # Hide the "sharing indicator", it's especially annoying
              # with tiling WMs on wayland
              "privacy.webrtc.legacyGlobalIndicator" = false;

              # Actual settings
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
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;

              "browser.newtabpage.pinned" = false;
              "browser.protections_panel.infoMessage.seen" = true;
              "browser.quitShortcut.disabled" = true;

              "browser.ssb.enabled" = true;
              "browser.toolbars.bookmarks.visibility" = "never";
              #"browser.urlbar.placeholderName" = "Startpage";
              "browser.urlbar.suggest.openpage" = false;
              "datareporting.policy.dataSubmissionEnable" = false;
              "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

              "extensions.getAddons.showPane" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "extensions.extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
              "extensions.update.enabled" = false;
              "extensions.webcompat.enable_picture_in_picture_overrides" = true;
              "extensions.webcompat.enable_shims" = true;
              "extensions.webcompat.perform_injections" = true;
              "extensions.webcompat.perform_ua_overrides" = true;

              "network.trr.mode" = 2;
              "network.trr.custom_uri" = "1.1.1.1";
              "network.trr.uri" = "1.1.1.1";

              "signon.rememberSignons" = false;
              "browser.startup.page" = 0;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "app.shield.optoutstudies.enabled" = false;
              "browser.contentblocking.category" = "strict";
              "browser.shell.checkDefaultBrowser" = false;
              "dom.security.https_only_mode" = true;
              "dom.security.https_only_mode_ever_enabled" = true;
              "identity.fxaccounts.enabled" = false;
              "privacy.trackingprotection.enabled" = true;
              "privacy.trackingprotection.socialtracking.enabled" = true;
              "privacy.donottrackheader.enabled" = true;
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
