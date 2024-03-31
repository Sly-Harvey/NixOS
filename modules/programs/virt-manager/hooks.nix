{
  pkgs,
  lib,
  ...
}: {
  virtualisation.libvirtd.hooks.qemu = {
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

          if [ "$GUEST_NAME" != "win10" ]; then
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
}
