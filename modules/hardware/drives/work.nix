{ lib, ... }:
{
  fileSystems."/mnt/work" = lib.mkForce {
    device = "/dev/disk/by-uuid/f6f6d68c-68f8-4c50-8155-105a22b9ff35";
    fsType = "ext4";
    options = [
      "defaults" # Default flags
      "async" # Run all operations async
      "nofail" # Don't error if not plugged in
      "x-gvfs-show" # Show in file explorer
      "x-systemd.mount-timeout=5" # Timout for error
      "X-mount.mkdir" # Make dir if it doesn't exist
    ];
  };
}
