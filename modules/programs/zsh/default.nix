{
  home-manager,
  username,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${username} = _: {
    home.file.".config/zsh/.p10k.zsh" = {
      source = ./.p10k.zsh;
    };
    home.file.".config/zsh/templates" = {
      source = ./templates;
      recursive = true;
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      history.size = 100000;
      dotDir = ".config/zsh";
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      oh-my-zsh = {
        # Plug-ins
        enable = true;
        plugins = ["git" "gitignore" "aliases""z"];
      };
      initExtra = ''
        # Powerlevel10k Zsh theme
        #source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh
      '';
      envExtra = ''
              # Defaults
        export XMONAD_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/xmonad" # xmonad.hs is expected to stay here
        export XMONAD_DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"
        export XMONAD_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"

        if [ -z "$XDG_CONFIG_HOME" ] ; then
            export XDG_CONFIG_HOME="$HOME/.config"
        fi
        if [ -z "$XDG_DATA_HOME" ] ; then
            export XDG_DATA_HOME="$HOME/.local/share"
        fi
        if [ -z "$XDG_CACHE_HOME" ] ; then
            export XDG_CACHE_HOME="$HOME/.cache"
        fi

        # path+=("$HOME/.local/bin")
        # export PATH="$PATH:''${$(find $HOME/.local/bin -maxdepth 1 -type d -printf %p:)%%:}"

        ### PATH
        if [ -d "$HOME/.bin" ] ;
          then PATH="$HOME/.bin:$PATH"
        fi

        if [ -d "$HOME/.local/bin" ] ;
          then PATH="$HOME/.local/bin:$PATH"
        fi

        if [ -d "$HOME/.emacs.d/bin" ] ;
          then PATH="$HOME/.emacs.d/bin:$PATH"
        fi

        if [ -d "$HOME/Applications" ] ;
          then PATH="$HOME/Applications:$PATH"
        fi

        if [ -d "/var/lib/flatpak/exports/bin/" ] ;
          then PATH="/var/lib/flatpak/exports/bin/:$PATH"
        fi

        if [ -d "$HOME/.config/emacs/bin/" ] ;
          then PATH="$HOME/.config/emacs/bin/:$PATH"
        fi
        function lf {
            tmp="$(mktemp)"
            # `command` is needed in case `lfcd` is aliased to `lf`
            command lf -last-dir-path="$tmp" "$@"
            if [ -f "$tmp" ]; then
                dir="$(cat "$tmp")"
                rm -f "$tmp"
                if [ -d "$dir" ]; then
                    if [ "$dir" != "$(pwd)" ]; then
                        cd "$dir"
                    fi
                fi
            fi
        }
        function ex {
         if [ -z "$1" ]; then
            # display usage if no parameters given
            echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
            echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
         else
            for n in "$@"
            do
              if [ -f "$n" ] ; then
                  case "''${n%,}" in
                    *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                                 tar xvf "$n"       ;;
                    *.lzma)      unlzma ./"$n"      ;;
                    *.bz2)       bunzip2 ./"$n"     ;;
                    *.cbr|*.rar)       unrar x -ad ./"$n" ;;
                    *.gz)        gunzip ./"$n"      ;;
                    *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
                    *.z)         uncompress ./"$n"  ;;
                    *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                                 7z x ./"$n"        ;;
                    *.xz)        unxz ./"$n"        ;;
                    *.exe)       cabextract ./"$n"  ;;
                    *.cpio)      cpio -id < ./"$n"  ;;
                    *.cba|*.ace)      unace x ./"$n"      ;;
                    *)
                                 echo "extract: '$n' - unknown archive method"
                                 return 1
                                 ;;
                  esac
              else
                  echo "'$n' - file does not exist"
                  return 1
              fi
            done
         fi
        }
      '';
      shellGlobalAliases = {
        UUID = "$(uuidgen | tr -d \\n)";
        G = "| grep";
      };
      shellAliases = {
        cls = "clear";
        l = "eza -lh  --icons=auto"; # long list
        ls = "eza -1   --icons=auto"; # short list
        ll = "eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
        ld = "eza -lhD --icons=auto"; # long list dirs
        tree = "eza --tree"; # dir tree
        un = "$aurhelper -Rns"; # uninstall package
        up = "$aurhelper -Syu"; # update system/package/aur
        pl = "$aurhelper -Qs"; # list installed package
        pa = "$aurhelper -Ss"; # list availabe package
        pc = "$aurhelper -Sc"; # remove unused cache
        po = "$aurhelper -Qtdq | $aurhelper -Rns -"; # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
        zshrc = "nvim ~/.zshrc";
        vc = "code --disable-gpu"; # gui code editor
        nv = "nvim";
        nf = "neofetch";
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -vI";
        bc = "bc -ql";
        mkd = "mkdir -pv";
        tp = "trash-put";
        tpr = "trash-restore";
        grep = "grep --color=always";

        # Nixos
        list-gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system/";
        find-store-path = '' function { nix-shell -p $1 --command "nix eval -f "<nixpkgs>" --raw $1" }'';
        rebuild-default = '' function {
            pushd ~/NixOS &> /dev/null
            sudo ./install.sh --Copy-Hardware
            popd &> /dev/null
          }'';
        rebuild-desktop = "clear && sudo nixos-rebuild switch --flake ~/NixOS#Desktop";
        rebuild-laptop = "clear && sudo nixos-rebuild switch --flake ~/NixOS#Laptop";

        # Directory Shortcuts.
        dev = "cd /mnt/seagate/dev/";
        dots = "cd ~/.dotfiles/";
        nvimdir = "cd ~/.config/nvim/";
        cppdir = "cd /mnt/seagate/dev/C++/";
        zigdir = "cd /mnt/seagate/dev/Zig/";
        csdir = "cd /mnt/seagate/dev/C#/";
        rustdir = "cd /mnt/seagate/dev/Rust/";
        pydir = "cd /mnt/seagate/dev/Python/";
        javadir = "cd /mnt/seagate/dev/Java/";
        luadir = "cd /mnt/seagate/dev/lua/";
        webdir = "cd /mnt/seagate/dev/Website/";
        seagate = "cd /mnt/seagate/";
        media = "cd /mnt/seagate/media/";
        games = "cd /mnt/games/";
      };
    };

    #home.file.".zshrc" = {
    #  source = ./.zshrc;
    #};
    #home.file.".zshenv" = {
    #  source = ./.zshenv;
    #};
    #home.file.".powerlevel10k" = {
    #  source = ./.powerlevel10k;
    #  recursive = true;
    #};
    #home.file.".oh-my-zsh" = {
    #  source = ./.oh-my-zsh;
    #  recursive = true;
    #};
  };
}
