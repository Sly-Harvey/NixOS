{ pkgs, ... }:
pkgs.writeShellScriptBin "waybarcava" ''
  bar="▁▂▃▄▅▆▇█"
  dict="s/;//g"

  bar_length=''${#bar}

  for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/''${bar:$i:1}/g"
  done

  config_file="/tmp/bar_cava_config"
  cat >"$config_file" <<EOF
[general]
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

  ${pkgs.procps}/bin/pkill -f "cava -p $config_file"

  for monitor in $(hyprctl monitors | ${pkgs.gnugrep}/bin/grep "ID" | ${pkgs.gawk}/bin/awk '{print $2}'); do
    ${pkgs.cava}/bin/cava -p "$config_file" | ${pkgs.gnused}/bin/sed -u "$dict"
  done
''
