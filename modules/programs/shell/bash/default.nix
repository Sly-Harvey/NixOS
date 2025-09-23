{ pkgs, ... }:
{
  programs.bash = {
    promptInit = ''
      if command -v starship; then
        eval "$(starship init bash)"
      fi
    '';
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
      cgen = ''
          {
            if [ -d "$1" ]; then
            echo "Directory \"$1\" already exists!"
            return 1
            fi
            mkdir $1 && cd $1
            cat ~/.config/zsh/templates/ListTemplate.txt >> CMakeLists.txt
            mkdir src
            mkdir include
            cat ~/.config/zsh/templates/HelloWorldTemplate.txt >> src/main.cpp
            cat ~/.config/zsh/templates/shell.txt >> shell.nix
            cat ~/.config/zsh/templates/envrc-nix.txt >> .envrc
            direnv allow
          #echo "Created the following Directories and files."
          ${pkgs.eza}/bin/eza --icons=auto --tree .
        }
      '';
      crun = ''
        {
          #VAR=$\{1:-.}
          mkdir build 2> /dev/null
          ${pkgs.cmake}/bin/cmake -B build
          ${pkgs.cmake}/bin/cmake --build build
          build/main
        }
      '';
      crun-mingw = ''
        {
          #VAR=$\{1:-.}
          mkdir build-mingw 2> /dev/null
          x86_64-w64-mingw32-cmake -B build-mingw
          make -C build-mingw
          build-mingw/main.exe
        }
      '';
      cbuild = ''
        {
          mkdir build 2> /dev/null
          ${pkgs.cmake}/bin/cmake -B build
          ${pkgs.cmake}/bin/cmake --build build
        }
      '';
      cbuild-mingw = ''
        {
          mkdir build-mingw 2> /dev/null
          x86_64-w64-mingw32-cmake -B build-mingw
          ${pkgs.gnumake}/bin/make -C build-mingw
        }
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
      vc = "code"; # gui code editor
      nv = "nvim";
      nf = "${pkgs.microfetch}/bin/microfetch";
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
      list-gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system/";
      find-store-path = ''function { nix-shell -p $1 --command "nix eval -f "<nixpkgs>" --raw $1" }'';
      update-input = "nix flake lock --update-input $@";
      rebuild = "${../../../desktop/hyprland/scripts/rebuild.sh}";
      build-iso = "nix build .#nixosConfigurations.iso.config.system.build.isoImage";
      sysup = "sudo nixos-rebuild switch --flake ~/NixOS#Default --upgrade-all --show-trace";

      # Directory Shortcuts.
      dots = "cd ~/NixOS/";
      work = "cd /mnt/work/";
      projects = "cd /mnt/work/Projects/";
      proj = "cd /mnt/work/Projects/";
      dev = "cd /mnt/work/Projects/";
      # dev = "cd /mnt/work/dev/";
      # nixdir = "cd /mnt/work/dev/nix/";
      # cppdir = "cd /mnt/work/dev/C++/";
      # zigdir = "cd /mnt/work/dev/Zig/";
      # csdir = "cd /mnt/work/dev/C#/";
      # rustdir = "cd /mnt/work/dev/Rust/";
      # pydir = "cd /mnt/work/dev/Python/";
      # javadir = "cd /mnt/work/dev/Java/";
      # luadir = "cd /mnt/work/dev/lua/";
      # webdir = "cd /mnt/work/dev/Website/";
    };
  };
}
