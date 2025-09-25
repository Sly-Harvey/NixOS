{ pkgs, lib, ... }:
{
  # Only enable either docker or podman -- Not both
  virtualisation = {
    spiceUSBRedirection.enable = true;

    docker = {
      enable = true;
    };

    podman.enable = false;

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
      hooks.qemu = {
        "passthrough" = lib.getExe (
          pkgs.writeShellApplication {
            name = "qemu-hook";

            runtimeInputs = with pkgs; [
              libvirt
              systemd
              kmod
            ];

            text = ''
              GUEST_NAME="$1"
              OPERATION="$2"

              if [ "$GUEST_NAME" != "win11-passthrough" ]; then
                exit 0;
              fi

              if [ "$OPERATION" == "prepare" ]; then
                systemctl stop display-manager.service
                modprobe -r -a nvidia_drm nvidia_uvm nvidia_modeset nvidia
                virsh nodedev-detach pci_0000_01_00_0
                modprobe vfio-pci
              fi

              if [ "$OPERATION" == "release" ]; then
                virsh nodedev-reattach pci_0000_01_00_0
                modprobe -a nvidia nvidia_modeset nvidia_uvm nvidia_drm
                systemctl start display-manager.service
              fi
            '';
          }
        );
      };
    };

    virtualbox.host = {
      enable = false;
      enableExtensionPack = true;
    };
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  programs = {
    virt-manager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    win-virtio
    win-spice

    lazydocker
    docker-client
  ];
}
