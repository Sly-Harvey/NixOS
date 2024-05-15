{
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = _: {
    xdg.configFile."lf/icons".source = ./icons;
    programs.lf = {
      enable = true;
      settings = {
        preview = true;
        drawbox = false;
        hidden = true;
        ignorecase = true;
        icons = true;
      };
      keybindings = {
        "<enter>" = "$nvim $f";
        do = "dragon-out";
        e = "open-with-editor";
        au = "unarchive";
        ae = "$wine $f";
        dd = "trash";
        dr = "restore_trash";
        p = "paste";
        x = "cut";
        y = "copy";
        R = "reload";
        mf = "mkfile";
        md = "mkdir";
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
        dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
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
              $EDITOR $ans
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
                  *.zip) ${pkgs.unzip}/bin/unzip "$f" ;;
                  *.tar.gz) ${pkgs.gnutar}/bin/tar -xzvf "$f" ;;
                  *.tar.bz2) ${pkgs.gnutar}/bin/tar -xjvf "$f" ;;
                  *.tar) ${pkgs.gnutar}/bin/tar -xvf "$f" ;;
                  *) echo "Unsupported format" ;;
              esac
            }}
        '';
        trash = ''
          ''${{
            files=$(printf "$fx" | tr '\n' ';')
            while [ "$files" ]; do
              file=''${files%%;*}

              ${pkgs.trash-cli}/bin/trash-put "$(basename "$file")"
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
              ${pkgs.trash-cli}/bin/trash-restore
            }}
        '';
      };
      extraConfig = let
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5

          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
              ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
          fi

          ${pkgs.pistol}/bin/pistol "$file"
        '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
    };
  };
}
