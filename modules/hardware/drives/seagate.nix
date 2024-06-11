# This module uses nouveau with NVK which is the nvidia open-source user-space driver and is not recommended to use as of 30/05/24 since it is very unstable
{...}: {
  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/E212-7894";
    fsType = "auto";
    options = [
      "X-mount.mkdir"
      "uid=1000"
      "gid=100"
      "noatime"
      "rw"
      "user"
      "exec"
      "umask=000"
      "nofail"
      # "auto"
      "x-gvfs-show"
      # "x-systemd.automount"
      "x-systemd.mount-timeout=5"
    ];
  };
}
