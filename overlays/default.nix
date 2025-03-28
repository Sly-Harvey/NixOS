{inputs, ...}: {
  # additions = final: _prev: import ../pkgs {pkgs = final;};

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    nur = inputs.nur.overlays.default;
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
    };

    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });
  };
}
