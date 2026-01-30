{ pkgs, host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname bluetoothSupport;
in
{
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = bluetoothSupport;
      powerOnBoot = bluetoothSupport;
      settings = {
        General = {
          Name = hostname;
          ControllerMode = "dual";
          FastConnectable = true;
          Experimental = true;
          KernelExperimental = true;
          JustWorksRepairing = "always";
          SecureConnections = "on";
        };
        GATT = {
          Cache = "always";
          Channels = 3;
        };
        Policy = {
          AutoEnable = true;
          ReconnectAttempts = 7;
          ReconnectIntervals = "1,2,4,8,16,32,64";
          ResumeDelay = 1;
        };
      };
    };
  };
}
