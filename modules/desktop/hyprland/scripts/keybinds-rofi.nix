{ pkgs, ... }:
pkgs.writeShellScriptBin "keybinds-show" ''
  ${pkgs.procps}/bin/pkill yad || true

  if ${pkgs.procps}/bin/pidof rofi > /dev/null; then
    ${pkgs.procps}/bin/pkill rofi
  fi

  keybinds_conf="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.conf"
  rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
  r_override="entry{placeholder:'Search KeyBinds...';}"
  msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

  keybinds=$(cat "$keybinds_conf" | ${pkgs.gnugrep}/bin/grep -E '^bind')

  if [[ -z "$keybinds" ]]; then
    echo "no keybinds found."
    exit 1
  fi

  display_keybinds=$(echo "$keybinds" | ${pkgs.gnused}/bin/sed 's/\$mainMod/SUPER/g')

  echo "$display_keybinds" | ${pkgs.rofi}/bin/rofi -dmenu -i -theme-str "$r_override" -config "$rofi_theme" -mesg "$msg"
''
