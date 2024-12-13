{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ../common.nix
    ../../modules/desktop/hyprland # Enable hyprland window manager
    ../../modules/programs/games

    ../../modules/hardware/video/nvidia.nix # Enable nvidia proprietary drivers
    # ../../modules/hardware/video/amdgpu.nix # Enable amdgpu drivers

    ../../modules/hardware/drives
    ./hardware-configuration.nix
  ];

  # Home-manager config
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        krita
        gimp
        # godot_4
        # unityhub
        # gparted
      ];
    })
  ];

  environment.systemPackages = with pkgs; [
  ];

  networking.hostName = hostname; # Define your hostname.
}
