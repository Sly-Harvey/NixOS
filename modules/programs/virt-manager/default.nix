{pkgs, ...}: {
  imports = [./hooks.nix];

  # packages
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
  ];

  # virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  # virt-manager
  programs.virt-manager.enable = true;
}
