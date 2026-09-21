{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    virtio-win
    win-spice

    lazydocker
    docker-client
  ];

  programs = {
    virt-manager.enable = true;
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  boot.kernelParams = [
    "iommu=pt"
    "intel_iommu=on"
    "amd_iommu=on"
  ];

  virtualisation = {
    virtualbox.host = {
      enable = false;
      enableExtensionPack = true;
    };

    # Only enable either docker or podman -- Not both
    docker = {
      enable = true;
    };
    podman.enable = false;

    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
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
              OBJECT="$1"
              OPERATION="$2"

              if [ "$OBJECT" == "win11-passthrough" ]; then
                case "$OPERATION" in
                  "prepare")
                    systemctl stop display-manager.service
                    systemctl isolate multi-user.target

                    if test -e "/tmp/vfio-is-nvidia"; then
                      rm -f /tmp/vfio-is-nvidia
                    elif test -e "/tmp/vfio-is-amd"; then
                      rm -f /tmp/vfio-is-amd
                    fi

                    # Unbind VTconsoles if currently bound
                    if test -e "/tmp/vfio-bound-consoles"; then
                      rm -f /tmp/vfio-bound-consoles
                    fi
                    for (( i = 0; i < 16; i++)) do
                      if test -x /sys/class/vtconsole/vtcon"''${i}"; then
                          if [ "$(grep -c "frame buffer" /sys/class/vtconsole/vtcon"''${i}"/name)" = 1 ]; then
                             echo 0 > /sys/class/vtconsole/vtcon"''${i}"/bind
                               echo "$i" >> /tmp/vfio-bound-consoles
                          fi
                      fi
                    done

                    if lspci -nn | grep -e VGA | grep -s NVIDIA ; then
                      grep -qsF "true" "/tmp/vfio-is-nvidia" || echo "true" >/tmp/vfio-is-nvidia
                      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
                      modprobe -r -a nvidia_drm
                      modprobe -r -a nvidia_uvm
                      modprobe -r -a nvidia_modeset
                      modprobe -r -a nvidia
                      modprobe -r -a i2c_nvidia_gpu
                      modprobe -r -a drm_kms_helper
                      modprobe -r -a drm
                    fi

                    if lspci -nn | grep -e VGA | grep -s AMD ; then
                      grep -qsF "true" "/tmp/vfio-is-amd" || echo "true" >/tmp/vfio-is-amd
                      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
                      modprobe -r -a drm_kms_helper
                      modprobe -r -a amdgpu
                      modprobe -r -a radeon
                      modprobe -r -a drm
                    fi

                    virsh nodedev-detach pci_0000_01_00_0
                    modprobe vfio
                    modprobe vfio-pci vfio_pci
                    ## modprobe vfio_iommu_type1
                    ## modprobe vfio_iommu_type2
                  ;;

                  "release")
                    modprobe -r vfio
                    modprobe -r vfio-pci vfio_pci
                    modprobe -r vfio_iommu_type1
                    modprobe -r vfio_iommu_type2

                    if grep -q "true" "/tmp/vfio-is-nvidia"; then
                      modprobe drm
                      modprobe drm_kms_helper
                      modprobe i2c_nvidia_gpu
                      modprobe nvidia
                      modprobe nvidia_modeset
                      modprobe nvidia_drm
                      modprobe nvidia_uvm
                    fi

                    if grep -q "true" "/tmp/vfio-is-amd"; then
                      modprobe drm
                      modprobe amdgpu
                      modprobe radeon
                      modprobe drm_kms_helper
                    fi

                    systemctl start display-manager.service

                    input="/tmp/vfio-bound-consoles"
                    while read -r consoleNumber; do
                      if test -x /sys/class/vtconsole/vtcon"''${consoleNumber}"; then
                          if [ "$(grep -c "frame buffer" "/sys/class/vtconsole/vtcon''${consoleNumber}/name")" \
                               = 1 ]; then
                        echo 1 > /sys/class/vtconsole/vtcon"''${consoleNumber}"/bind
                          fi
                      fi
                    done < "$input"

                    virsh nodedev-reattach pci_0000_01_00_0
                    modprobe -a nvidia nvidia_modeset nvidia_uvm nvidia_drm
                  ;;
                esac
              fi
            '';
          }
        );
      };
    };
  };
}
