#!/usr/bin/env bash
# Clipboard Manager. This script uses cliphist, rofi, and wl-copy.

tmp_dir="/tmp/cliphist_rofi_previews"

trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir"

read -r -d '' gawk_prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("cliphist decode " grp[1] " > " tmp_dir "/" grp[1] "." grp[3])
    print \$0"\0icon\x1f"tmp_dir"/"grp[1]"."grp[3]
    next
}
1
EOF
# ---------------------------------------------

while true; do
  result=$(
    rofi -dmenu \
      -kb-custom-1 "Control-Delete" \
      -kb-custom-2 "Alt-Delete" \
      -theme "$HOME/.config/rofi/launchers/type-1/style-6.rasi" \
      < <(cliphist list | gawk -v tmp_dir="$tmp_dir" "$gawk_prog")
  )

  case "$?" in
  1)
    exit
    ;;
  0)
    case "$result" in
    "")
      continue
      ;;
    *)
      cliphist decode <<<"$result" | wl-copy
      exit
      ;;
    esac
    ;;
  10)
    cliphist delete <<<"$result"
    ;;
  11)
    cliphist wipe
    ;;
  esac
done
