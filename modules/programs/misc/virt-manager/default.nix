{pkgs, ...}: {
  imports = [./hooks.nix];

  # virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["sep"];
  users.users.sep.extraGroups = [ "libvirtd" ];
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
    spice-autorandr.enable = true;
  };
  
  # packages
  environment.systemPackages = with pkgs; [
    virt-viewer
    guestfs-tools
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    win-virtio
    win-spice
  ];

  # virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm; # TODO: Test
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };
}
