{pkgs, ...}: {
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
}
