{
  pkgs,
  settings,
  ...
}: {
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix {};
  lact = pkgs.callPackage ./lact.nix {};
  sddm-astronaut = pkgs.callPackage ./sddm-themes/astronaut.nix {theme = settings.sddmTheme;};
}
