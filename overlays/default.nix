{
  inputs,
  settings,
  ...
}:
{
  # Overlay custom derivations into nixpkgs so you can use pkgs.<name>
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit settings;
    };

  # Package modifications and external overlays
  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    # Apply NUR overlay for additional packages
    nur = import inputs.nur {
      nurpkgs = prev;
      pkgs = final;
    };

    # Provide access to stable packages
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
