{ pkgs, ... }:
{
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };
  environment.systemPackages = with pkgs; [ lact ];
}
