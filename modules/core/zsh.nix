{
  self,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.zsh = {
          enable = true;
          autosuggestion.enable = false; # Loaded lazily via zsh-defer
          syntaxHighlighting.enable = false; # Loaded lazily via zsh-defer
          enableCompletion = false; # Loaded lazily via zsh-defer
          history.size = 100000;
          history.path = "\${XDG_DATA_HOME}/zsh/history";
          dotDir = "${config.xdg.configHome}/zsh";
          plugins = [
            {
              name = "nix-zsh-completions";
              src = pkgs.nix-zsh-completions;
            }
          ];
          initContent = ''
            fpath=(${pkgs.nix-zsh-completions}/share/zsh/site-functions $fpath)

            # Source zsh-defer first, then use it for lazy loading
            source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh

            # Lazy load heavy components with zsh-defer for faster startup
            zsh-defer -c 'autoload -Uz compinit && compinit -C'
            zsh-defer -c 'source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
            zsh-defer -c 'source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
            zsh-defer -c 'source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh'
            zsh-defer -c 'source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh; bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'
            zsh-defer -c 'eval "$(direnv hook zsh)"' 2>/dev/null
            zsh-defer -c 'eval "$(zoxide init zsh)"' 2>/dev/null

            # Sudo widget (double ESC to prepend sudo - replaces oh-my-zsh sudo plugin)
            sudo-command-line() {
              [[ -z $BUFFER ]] && zle up-history
              if [[ $BUFFER == sudo\ * ]]; then
                LBUFFER="''${LBUFFER#sudo }"
              else
                LBUFFER="sudo $LBUFFER"
              fi
            }
            zle -N sudo-command-line
            bindkey '\e\e' sudo-command-line

            # Key Bindings
            bindkey '^a' beginning-of-line
            bindkey '^e' end-of-line

            # options
            unsetopt menu_complete
            unsetopt flowcontrol

            setopt prompt_subst
            setopt always_to_end
            setopt append_history
            setopt auto_menu
            setopt complete_in_word
            setopt extended_history
            setopt hist_expire_dups_first
            setopt hist_ignore_dups
            setopt hist_ignore_space
            setopt hist_verify
            setopt inc_append_history
            setopt share_history

            # Lazy load completion styles (depends on compinit)
            zsh-defer -c '
              zstyle ":completion:*" menu select
              zstyle ":completion:*" list-colors "''${(s.:.)LS_COLORS}"
              zstyle ":completion:*" verbose yes
              zstyle ":completion:*:descriptions" format "%F{yellow}-- %d --%f"
              zstyle ":completion:*:messages" format "%F{purple}-- %d --%f"
              zstyle ":completion:*:warnings" format "%F{red}-- no matches found --%f"
              zstyle ":completion:*" group-name ""
              zstyle ":completion:*:*:-command-:*:*" group-order aliases builtins functions commands
              zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
              zstyle ":completion:*" extra-verbose yes
              zstyle ":completion:*" use-cache on
              zstyle ":completion:*" cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
              zstyle ":completion:*" file-list all
              zstyle ":completion:*:options" description yes
              zstyle ":completion:*:options" auto-description "%d"
            '
          '';
          envExtra = ''
            # Defaults
            export XMONAD_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/xmonad" # xmonad.hs is expected to stay here
            export XMONAD_DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"
            export XMONAD_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"

            export FZF_DEFAULT_OPTS=" \
            --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
            --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
            --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
          '';
          shellGlobalAliases = {
            UUID = "$(uuidgen | tr -d \\n)";
            G = "| grep";
          };
          shellAliases = {
            lf = ''
                {
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
            '';
            fnew = ''
              if [ -d "$2" ]; then
                echo "Directory \"$2\" already exists!"
                return 1
              fi
              nix flake new $2 --template ${self}/dev-shells#$1
              cd $2
              direnv allow
            '';

            finit = ''
              nix flake init --template ${self}/dev-shells#$1
              direnv allow
            '';
            cdown = ''
              N=$1
              while [[ $((--N)) -gt  0 ]]
                do
                  echo "$N" |  figlet -c | lolcat &&  sleep 1
              done
            '';
            cls = "clear";
            tml = "tmux list-sessions";
            tma = "tmux attach";
            tms = "tmux attach -t $(tmux ls -F '#{session_name}: #{session_path} (#{session_windows} windows)' | fzf | cut -d: -f1)";
            l = "${pkgs.eza}/bin/eza -lh  --icons=auto"; # long list
            ls = "${pkgs.eza}/bin/eza -1   --icons=auto"; # short list
            ll = "${pkgs.eza}/bin/eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
            ld = "${pkgs.eza}/bin/eza -lhD --icons=auto"; # long list dirs
            tree = "${pkgs.eza}/bin/eza --icons=auto --tree"; # dir tree
            vc = "code --disable-gpu"; # gui code editor
            nv = "nvim";
            nf = "${pkgs.microfetch}/bin/microfetch";
            ff = "fastfetch";
            cp = "cp -iv";
            mv = "mv -iv";
            rm = "rm -vI";
            bc = "bc -ql";
            mkd = "mkdir -pv";
            tp = "${pkgs.trash-cli}/bin/trash-put";
            tpr = "${pkgs.trash-cli}/bin/trash-restore";
            grep = "grep --color=always";
            pokemon = "pokego --random 1-8 --no-title";

            # Nixos
            list-gens = "nixos-rebuild list-generations";
            find-store-path = ''function { nix-shell -p $1 --command "nix eval -f \"<nixpkgs>\" --raw $1" }'';
            update-input = "nix flake update $@";
            sysup = "nix flake update --flake ~/NixOS && rebuild";

            # Directory Shortcuts.
            dots = "cd ~/NixOS/";
            games = "cd /mnt/games/";
            work = "cd /mnt/work/";
            media = "cd /mnt/work/media/";
            projects = "cd /mnt/work/Projects/";
            proj = "cd /mnt/work/Projects/";
            dev = "cd /mnt/work/Projects/";
          };
        };
      }
    )
  ];
}
