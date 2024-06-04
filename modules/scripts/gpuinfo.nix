{pkgs, ...}:
pkgs.writeShellScriptBin "gpuinfo" ''
  vulkaninfo | grep -i "deviceName\|driverID"
''
