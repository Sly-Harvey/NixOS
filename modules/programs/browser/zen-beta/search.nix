{ pkgs, ... }:
{
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
    "google"
  ];
  engines =
    let
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    in
    {
      "Startpage" = {
        urls = [
          {
            template = "https://www.startpage.com/sp/search?query={searchTerms}&prfe=038360dac42617e2336286a019b197c1db650883a5698f4ae16e38c5da02bde0a35c84e4f806f082758d15e14a7000393be0c9535dd6dd17a4785a4ae44d33f74b43cb4a213e098bcd169762";
          }
        ];
        # icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        icon = "https://www.startpage.com/sp/cdn/favicons/favicon-gradient.ico";
        definedAliases = [ "@sp" ];
        updateInterval = 24 * 60 * 60 * 1000;
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
        icon = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
        definedAliases = [ "@br" ];
        updateInterval = 24 * 60 * 60 * 1000;
      };
      "Searx" = {
        urls = [ { template = "https://searx.aicampground.com/?q={searchTerms}"; } ];
        # icon = "https://nixos.wiki/favicon.png";
        icon = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/searxng/searxng/edf6d96625444b5b214b4ca0e2885467ed265411/src/brand/searxng-wordmark.svg";
          sha256 = "sha256:0lnc0cf7rgl6a54zm4i5z3i3npp87bg9kmwf5mii88gys980y32g";
        };
        definedAliases = [ "@sx" ];
      };
      "NixOS Packages" = {
        inherit icon;
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
        definedAliases = [
          "@np"
          "@nixpkgs"
        ];
      };
      "NixOS Options" = {
        inherit icon;
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
        definedAliases = [
          "@no"
          "@nixopts"
        ];
      };
      "NixOS Wiki" = {
        inherit icon;
        urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "@nw" ];
      };
      "Home Manager" = {
        inherit icon;
        urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
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
        definedAliases = [
          "@hm"
          "@home"
          "'homeman"
        ];
      };
      "My NixOS" = {
        inherit icon;
        urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
        definedAliases = [
          "@mn"
          "@nx"
          "@mynixos"
        ];
      };
      "Noogle" = {
        inherit icon;
        urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = [
          "@noogle"
          "@ng"
        ];
      };
      "youtube" = {
        urls = [ { template = "https://youtube.com/results?search_query={searchTerms}"; } ];
        definedAliases = [ "@yt" ];
      };
      "bing".metaData.hidden = true;
      "Ebay".metaData.hidden = true;
      "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
    };
}
