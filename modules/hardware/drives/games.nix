{ lib, ... }:
{
  fileSystems."/mnt/games" = lib.mkForce {
    device = "/dev/disk/by-uuid/01DA12C1CBDE9100";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "noatime"
      "umask=000"
      "nofail"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };
}
