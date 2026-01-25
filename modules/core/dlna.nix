{ host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname;
in
{

  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      friendly_name = "${hostname}";
      media_dir = [
        # A = Audio, P = Pictures, V, = Videos, PV = Pictures and Videos.
        # "A,/mnt/work/Pimsleur/Russian"
        "/mnt/work/Pimsleur"
        "/mnt/work/Media/Films"
        "/mnt/work/Media/Series"
        "/mnt/work/Media/Videos"
        "/mnt/work/Media/Music"
      ];
      inotify = "yes";
      log_level = "warn";
    };
  };
  users.users.minidlna = {
    extraGroups = [ "users" ]; # so minidlna can access the files.
  };
}
