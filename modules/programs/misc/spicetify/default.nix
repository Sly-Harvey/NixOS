{
  spicetify-nix,
  username,
  ...
}: {
  home-manager.users.${username} = {
    pkgs,
    lib,
    #spicetify-nix,
    ...
  }: let
    spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
  in {
    # allow spotify to be installed if you don't have unfree enabled already
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "spotify"
      ];

    # import the flake's module for your system
    imports = [spicetify-nix.homeManagerModule];

    # configure spicetify :)
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        # fullAppDisplay
        # shuffle # shuffle+ (special characters are sanitized out of ext names)
        # hidePodcasts
      ];
    };
  };
}
