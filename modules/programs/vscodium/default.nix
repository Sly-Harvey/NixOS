{ username
, pkgs
, ...
}: {
  home-manager.users.${username} = _: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        #jnoortheen.nix-ide
        arrterian.nix-env-selector
        eamodio.gitlens
        github.vscode-github-actions
        yzhang.markdown-all-in-one
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        # vscodevim.vim
        # tamasfe.even-better-toml
        # redhat.vscode-yaml
        # vadimcn.vscode-lldb
        # rust-lang.rust-analyzer
        ms-vscode.cpptools
        # ms-vscode.cmake-tools
        # ms-vscode.makefile-tools
        # ms-dotnettools.csharp
        ms-python.python
        # pkief.material-icon-theme
        # equinusocio.vsc-material-theme
        # dracula-theme.theme-dracula
      ];
      keybindings = [
        {
          key = "ctrl+q";
          command = "editor.action.commentLine";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+s";
          command = "workbench.action.files.saveFiles";
        }
      ];
      userSettings = {
        "update.mode" = "none";
        "extensions.autoUpdate" = false; # This stuff fixes vscode freaking out when theres an update
        "window.titleBarStyle" = "custom"; # needed otherwise vscode crashes, see https://github.com/NixOS/nixpkgs/issues/246509
        "window.menuBarVisibility" = "classic";
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'SymbolsNerdFont', 'monospace', monospace";
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', 'SymbolsNerdFont'";
        "editor.fontSize" = 16;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "catppuccin.accentColor" = "lavender";
        "vsicons.dontShowNewVersionMessage" = true;
        "explorer.confirmDragAndDrop" = false;
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = true; # minimap view
        "workbench.startupEditor" = "none";

        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.formatOnPaste" = true;

        "workbench.layoutControl.type" = "menu";
        "workbench.editor.limit.enabled" = true;
        "workbench.editor.limit.value" = 10;
        "workbench.editor.limit.perEditorGroup" = true;
        # "workbench.editor.showTabs" = "single";
        "explorer.openEditors.visible" = 0;
        "breadcrumbs.enabled" = true;
        "editor.renderControlCharacters" = false;
        # "workbench.activityBar.location" = "hidden";
        # "workbench.statusBar.visible" = false;
        "editor.stickyScroll.enabled" = false; # Top code preview
        "editor.scrollbar.verticalScrollbarSize" = 2;
        "editor.scrollbar.horizontalScrollbarSize" = 2;
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollbar.horizontal" = "hidden";
        "workbench.layoutControl.enabled" = false;

        "editor.mouseWheelZoom" = true;

        "C_Cpp.autocompleteAddParentheses" = true;
        "C_Cpp.formatting" = "vcFormat";
        "C_Cpp.vcFormat.newLine.closeBraceSameLine.emptyFunction" = true;
        "C_Cpp.vcFormat.newLine.closeBraceSameLine.emptyType" = true;
        "C_Cpp.vcFormat.space.beforeEmptySquareBrackets" = true;
        "C_Cpp.vcFormat.newLine.beforeOpenBrace.block" = "sameLine";
        "C_Cpp.vcFormat.newLine.beforeOpenBrace.function" = "sameLine";
        "C_Cpp.vcFormat.newLine.beforeElse" = false;
        "C_Cpp.vcFormat.newLine.beforeCatch" = false;
        "C_Cpp.vcFormat.newLine.beforeOpenBrace.type" = "sameLine";
        "C_Cpp.vcFormat.space.betweenEmptyBraces" = true;
        "C_Cpp.vcFormat.space.betweenEmptyLambdaBrackets" = true;
        "C_Cpp.vcFormat.indent.caseLabels" = true;
        "C_Cpp.intelliSenseCacheSize" = 2048;
        "C_Cpp.intelliSenseMemoryLimit" = 2048;
        "C_Cpp.default.browse.path" = [
          ''''${workspaceFolder}/**''
        ];
        "C_Cpp.default.cStandard" = "gnu11";
        "C_Cpp.inlayHints.parameterNames.hideLeadingUnderscores" = false;
        "C_Cpp.intelliSenseUpdateDelay" = 500;
        "C_Cpp.workspaceParsingPriority" = "medium";
        "C_Cpp.clang_format_sortIncludes" = true;
        "C_Cpp.doxygen.generatedStyle" = "/**";
      };
    };
  };
}
