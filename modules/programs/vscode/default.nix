{
  home-manager,
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = _: {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        tamasfe.even-better-toml
        redhat.vscode-yaml
        bbenoist.nix
        eamodio.gitlens
        vadimcn.vscode-lldb
        rust-lang.rust-analyzer
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        ms-vscode.makefile-tools
        ms-dotnettools.csharp
        # DISABLED BECAUSE IT MAKES NIXOS-REBUILD HANG LIKE CRAZY: ms-python.python
        pkief.material-icon-theme
        equinusocio.vsc-material-theme
        catppuccin.catppuccin-vsc
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
      ];
    };
  };
}
