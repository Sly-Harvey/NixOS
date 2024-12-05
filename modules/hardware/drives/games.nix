{...}: {
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/01DA12C1CBDE9100";
    fsType = "lowntfs-3g";
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
      # "async"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };
}
