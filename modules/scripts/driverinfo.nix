{pkgs, ...}:
pkgs.writeShellScriptBin "driverinfo" ''
  vulkaninfo | grep -i "deviceName\|driverID"
''
