{lib, ...}: {
  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/E212-7894";
    fsType = lib.mkForce "auto";
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
