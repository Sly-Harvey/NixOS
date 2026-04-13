{
  pkgs,
  terminal,
  ...
}:
pkgs.writeShellScriptBin "file-manager" ''
  term="${terminal}"
  case "$1" in
    thunar) exec thunar ;;
    dolphin) exec dolphin ;;
    nautilus) exec nautilus ;;
    pcmanfm) exec pcmanfm ;;
    nemo) exec nemo ;;
    yazi) exec ${terminal} --class "fileManager" -e yazi ;;
    lf) exec ${terminal} --class "fileManager" -e lf ;;
    nnn) exec ${terminal} --class "fileManager" -e nnn ;;
    ranger) exec ${terminal} --class "fileManager" -e ranger ;;
    mc) exec ${terminal} --class "fileManager" -e mc ;;
  esac
''
