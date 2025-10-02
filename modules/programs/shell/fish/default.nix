{
  self,
  pkgs,
  terminalFileManager,
  ...
}: {
  home-manager.sharedModules = [
    (_: {
          programs.fish = {
            enable = true;
            loginShellInit = ''
              # starship init fish | source
              # direnv hook fish | source
            '';
            interactiveShellInit  = ''
              zoxide init fish | source
              # starship init fish | source
              # direnv hook fish | source
              # bind ctrl-l "${terminalFileManager} \r"
            '';
            binds = {
              "ctrl-l".command = "${terminalFileManager} \r";
            };
            shellAliases = {
              nc = "rlwrap nc -lvnp";
              rscan = "rustscan --ulimit 5000 -a ";
              cls = "clear";
              l = "${pkgs.eza}/bin/eza -lh  --icons=auto"; # long list
              ls = "${pkgs.eza}/bin/eza -1   --icons=auto"; # short list
              ll = "${pkgs.eza}/bin/eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
              ld = "${pkgs.eza}/bin/eza -lhD --icons=auto"; # long list dirs
              tree = "${pkgs.eza}/bin/eza --icons=auto --tree"; # dir tree
              vc = "code --disable-gpu"; # gui code editor
              nv = "nvim";
              nf = "${pkgs.microfetch}/bin/microfetch";
              cd = "z";
              cp = "cp -iv";
              mv = "mv -iv";
              rm = "rm -vI";
              bc = "bc -ql";
              mkdir = "mkdir -pv";
              # tp = "${pkgs.trash-cli}/bin/trash-put";
              # tpr = "${pkgs.trash-cli}/bin/trash-restore";
              grep = "grep --color=always";
              pokemon = "pokego --random 1-8 --no-title";
    
              # Nixos
              list-gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system/";
              # find-store-path = ''function { nix-shell -p $1 --command "nix eval -f \"<nixpkgs>\" --raw $1" }'';
              # update-input = "nix flake update $@";
              rebuild = "${../../../desktop/hyprland/scripts/rebuild.sh}";
              sysup = "sudo nixos-rebuild switch --flake ~/NixOS#Default --upgrade-all --show-trace";
  
              # Directory Shortcuts.
              dots = "z ~/NixOS/";
              # games = "cd /mnt/games/";
              # work = "cd /mnt/work/";
              # media = "cd /mnt/work/media/";
              # projects = "cd /mnt/work/Projects/";
              # proj = "cd /mnt/work/Projects/";
              # dev = "cd /mnt/work/Projects/";
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
    })
  ];
}
