{pkgs, ...}:
pkgs.writeShellScriptBin "collect-garbage" ''
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
''
