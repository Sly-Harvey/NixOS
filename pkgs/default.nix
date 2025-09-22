{
  pkgs,
  settings,
  ...
}: {
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix {};
  sddm-astronaut = pkgs.callPackage ./sddm-themes/astronaut.nix {theme = settings.sddmTheme;};
  
  # Lint script for CI/CD
  lint = pkgs.writeShellScriptBin "lint" ''
    echo "Running Nix linting tools..."

    # Run statix for static analysis
    if command -v ${pkgs.statix}/bin/statix >/dev/null 2>&1; then
      echo "→ Running statix..."
      ${pkgs.statix}/bin/statix check .
    else
      echo "Warning: statix not available"
    fi

    # Run deadnix for dead code detection
    if command -v ${pkgs.deadnix}/bin/deadnix >/dev/null 2>&1; then
      echo "→ Running deadnix..."
      ${pkgs.deadnix}/bin/deadnix .
    else
      echo "Warning: deadnix not available"
    fi

    echo "Linting completed!"
  '';
}
