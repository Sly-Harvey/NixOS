{
  lib,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      xdg.configFile."lf/icons".source = ./icons;
      programs.lf =
        let
          inherit (lib) getExe getExe';
        in
        {
          enable = true;
          settings = {
            # period = 1; # dir update time in seconds
            preview = true;
            drawbox = false;
            hidden = true;
            ignorecase = true;
            icons = true;
          };
          keybindings = {
            m = "";
            d = "";
            f = "fzf";
            "." = "set hidden!";
            "<enter>" = "$nvim $f";
            "<space>" = "toggle"; # Select file (v to select all)
            do = "dragon-out"; # Drag and drop
            e = "open-with-editor";
            au = "unarchive";
            ae = "$wine $f"; # Run .exe
            dd = "cut";
            dD = "delete";
            # dR = "restore_trash";
            p = "paste";
            x = "cut";
            y = "copy";
            c = "copy";
            R = "reload";
            mf = "mkfile";
            md = "mkdir";
            mo = "$chmod +x $f";
            C = "clear";

            gn = "cd ~/NixOS";
            gD = "cd ~/Documents";
            gd = "cd ~/Downloads";
            gp = "cd ~/Pictures";
            gc = "cd ~/.config";
            gg = "cd ~/git-clone";
            gv = "cd ~/Videos";
            gt = "cd ~/.local/share/Trash/files";
          };
          commands = {
            open-with-editor = ''$$EDITOR $f'';
            dragon-out = ''%${getExe pkgs.xdragon} -a -x "$fx"'';
            mkdir = ''
              ''${{
                  printf "Directory Name: "
                  read ans
                  mkdir $ans
                }}
            '';
            mkfile = ''
              ''${{
                  printf "File Name: "
                  read ans
                  touch $ans
                }}
            '';
            setwallpaper = ''
              ''${{
                  setwallpaper "$f"
                }}
            '';
            unarchive = ''
              ''${{
                  case "$f" in
                      *.zip) ${getExe' pkgs.unzip "unzip"} "$f" ;;
                      *.7z) ${getExe' pkgs.p7zip "7z"} x "$f" ;;
                      *.rar) ${getExe' pkgs.unrar "unrar"} x "$f" ;;
                      *.tar) ${getExe' pkgs.gnutar "tar"} -xvf "$f" ;;
                      *.tar.xz|*.txz) ${getExe' pkgs.gnutar "tar"} xJvf $f;;
                      *.tar.gz|*.tgz) ${getExe' pkgs.gnutar "tar"} -xzvf "$f" ;;
                      *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) ${getExe' pkgs.gnutar "tar"} -xjvf "$f" ;;
                      *) echo "Unsupported format" ;;
                  esac
                }}
            '';
            fzf = ''
              ''${{
                res="$(find . | ${getExe pkgs.fzf} --reverse --header='Jump to location')"
                if [ -n "$res" ]; then
                    if [ -d "$res" ]; then
                        cmd="cd"
                    else
                        cmd="select"
                    fi
                    res="$(printf '%s' "$res" | sed 's/\\/\\\\/g;s/"/\\"/g')"
                    lf -remote "send $id $cmd \"$res\""
                fi
              }}
            '';
            trash = ''
              ''${{
                files=$(printf "$fx" | tr '\n' ';')
                while [ "$files" ]; do
                  file=''${files%%;*}

                  ${getExe' pkgs.trash-cli "trash-put"} "$(basename "$file")"
                  if [ "$files" = "$file" ]; then
                    files=\'\'
                  else
                    files="''${files#*;}"
                  fi
                done
              }}
            '';
            restore_trash = ''
              ''${{
                  ${getExe' pkgs.trash-cli "trash-restore"}
                }}
            '';
          };
          extraConfig =
            let
              previewer = pkgs.writeShellScriptBin "pv.sh" ''
                file=$1
                w=$2
                h=$3
                x=$4
                y=$5

                if [[ "$( ${getExe pkgs.file} -Lb --mime-type "$file")" =~ ^image ]]; then
                    ${getExe pkgs.kitty} +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
                    exit 1
                fi

                ${getExe pkgs.pistol} "$file"
              '';
              cleaner = pkgs.writeShellScriptBin "clean.sh" ''
                ${getExe pkgs.kitty} +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
              '';
            in
            ''
              set cleaner ${cleaner}/bin/clean.sh
              set previewer ${previewer}/bin/pv.sh
            '';
        };
    })
  ];
}
