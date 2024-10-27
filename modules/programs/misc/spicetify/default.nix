{spicetify-nix, ...}: {
  home-manager.sharedModules = [
    ({
      pkgs,
      lib,
      ...
    }: let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
    in {
      # allow spotify to be installed if you don't have unfree enabled already
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "spotify"
        ];

      # import the flake's module for your system
      imports = [spicetify-nix.homeManagerModules.default];

      # configure spicetify :)
      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";

        enabledExtensions = with spicePkgs.extensions; [
          adblock
          shuffle # shuffle+ (special characters are sanitized out of ext names)
          # fullAppDisplay
          # hidePodcasts
        ];
      };
    })
  ];
}
