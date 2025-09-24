{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe';
in
pkgs.writeShellScriptBin "driverinfo" ''
  ${getExe' pkgs.vulkan-tools "vulkaninfo"} | grep -i "deviceName\|driverID"
''
