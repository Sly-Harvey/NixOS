{
  inputs,
  settings,
  ...
}: {
  # Overlay custom derivations into nixpkgs so you can use pkgs.<pname>
  # additions = final: _prev: import ../pkgs {pkgs = final;};
  additions = final: prev: {
    pokego = prev.callPackage ../pkgs/pokego.nix {};
    lact = prev.callPackage ../pkgs/lact.nix {};
    sddm-astronaut = prev.callPackage ../pkgs/sddm-themes/astronaut.nix {
      theme = settings.sddmTheme;
    };
  };

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    nur = inputs.nur.overlays.default;
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
    };
  };
}
