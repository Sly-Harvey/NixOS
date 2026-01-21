{ pkgs, ... }:
pkgs.writeShellScriptBin "workspaces" ''
  WORKSPACES=(1 2 3 4 5 6 7 8 9 10)
  EXISTING=$(${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | .num')
  FOCUSED=$(${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.focused==true).num')
  echo -n " " # Add spacing before first workspace
  for ws in "''${WORKSPACES[@]}"; do
    if [ "$ws" -eq "$FOCUSED" ]; then
      echo -n "%{F#cba6f7}$ws%{F-} "
    # elif echo "$EXISTING" | grep -q "$ws"; then
    #   echo -n "%{F#89b4fa}$ws%{F-} "
    else
      echo -n "%{F#6c7086}$ws%{F-} "
    fi
  done
''
