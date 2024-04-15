{
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = _: {
    programs.vscode = {
      enable = true;
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
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
        # DISABLED BECAUSE IT MAKES NIXOS-REBUILD HANG LIKE CRAZY (Might be fixed now): ms-python.python
        pkief.material-icon-theme
        equinusocio.vsc-material-theme
        catppuccin.catppuccin-vsc
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
      ];
      /* userSettings = {
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Github Dark Colorblind (Beta)";
        "editor.fontFamily" = "'M+1Code Nerd Font','Droid Sans Mono', 'monospace', monospace";
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "markdown" = true;
          "scminput" = false;
        };
        "powershell.powerShellAdditionalExePaths" = "/run/current-system/sw/bin/pwsh";
      }; */
    };
  };
}
