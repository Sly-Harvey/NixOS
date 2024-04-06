{
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
  settings = {
    # Performance settings
    "gfx.webrender.all" = true; # Force enable GPU acceleration
    "media.ffmpeg.vaapi.enabled" = true;
    "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes
    "reader.parse-on-load.force-enabled" = true;
    "privacy.webrtc.legacyGlobalIndicator" = false;

    # Use cloudflare for better security/privacy
    "network.trr.mode" = 3; # 2
    "network.trr.custom_uri" = "1.1.1.1";
    "network.trr.uri" = "1.1.1.1";

    # Remove trackers
    "privacy.purge_trackers.enabled" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.donottrackheader.value" = 1;

    # Block more unwanted stuff
    "browser.contentblocking.category" = "strict";
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "signon.rememberSignons" = false;

    # General settings
    "ui.key.accelKey" = 17; # Set CTRL as master key
    "browser.newtabpage.pinned" = true; # false
    "browser.bookmarks.defaultLocation" = "toolbar";
    "browser.startup.page" = 3;
    "browser.newtab.url" = "about:blank";
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "app.shield.optoutstudies.enabled" = false;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "identity.fxaccounts.enabled" = false;
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

    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
    "extensions.update.enabled" = false;
    "extensions.webcompat.enable_picture_in_picture_overrides" = true;
    "extensions.webcompat.enable_shims" = true;
    "extensions.webcompat.perform_injections" = true;
    "extensions.webcompat.perform_ua_overrides" = true;
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
                        url = "https://www.startpage.com/sp/search?query={searchTerms}&prfe=dea8b8a2e1126185da987128a196ee5c47cdf324dce146f96b3b9157ab1f9e7166ae05d134c935eccc20f54e46222c8f1bb60faece00557b02e7a4e1fe397bc0f6750fbd3f7f580b241188&abp=-1";
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
                  urls = [
                    {
                      template = "https://mipmip.github.io/home-manager-option-search";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
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
            settings = settings;
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
