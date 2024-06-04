{pkgs, ...}:
pkgs.writeShellScriptBin "underwatt" ''
  # WARNING This script is setup for my gtx 1080 do not attempt to use this unless you know what settings your gpu can handle

  sudo nvidia-smi -i 0 -pm 1 # Set persistance mode
  sudo nvidia-smi -i 0 -pl 90 # Power limit (in watts)
  sudo nvidia-smi -gtt 78 # Target temperature
  # sudo nvidia-smi -i 0 -lgc 240,1706 # min,max clocks (Not supported for gtx 1080)

  # Overclock offset at all voltage levels (like raising the voltage curve in msi afterburner)
  # but i lowered the power limit so essentially we are undervolting to reduce gpu temps
  # nvidia-settings -a [gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=15 # Doesn't work on wayland
''
