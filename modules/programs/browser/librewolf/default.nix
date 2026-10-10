{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.librewolf = {
        enable = true;
        policies = import ../policies.nix { inherit lib; };
        languagePacks = [
          "en-GB"
          "en-US"
        ];
        profiles = {
          default = {
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
            settings = import ../settings.nix { inherit lib; };
            bookmarks = import ../bookmarks.nix;
            search = import ./search.nix { inherit pkgs; };
            # userChrome = builtins.readFile ./userChrome.css;
            # userContent = builtins.readFile ./userContent.css;
            userContent = ''
                /* @-moz-document url("about:newtab"), url("about:home"), url("about:privatebrowsing") { */
                @-moz-document url("about:newtab"), url("about:home") {
                body,
                #root {
                  min-height: 100vh !important;
                  background:
                    linear-gradient(rgba(6, 10, 16, 0.18), rgba(6, 10, 16, 0.38)),
                    url("file://${../../../wallpapers/storm.jpg}") center / cover no-repeat fixed !important;
                }
              }
            '';
            extraConfig = ''
              ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
              ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
              ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
            '';
          };
        };
      };
    })
  ];
}
