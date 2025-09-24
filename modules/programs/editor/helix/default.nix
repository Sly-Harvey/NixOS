{
  pkgs,
  inputs,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.helix = {
        enable = true;
        settings = {
          theme = "catppuccin_mocha";
          editor = {
            auto-completion = true;
            smart-tab.enable = false;
            line-number = "relative";
            indent-guides.render = true;
            true-color = true;
            cursorline = true;
            cursorcolumn = false;
            default-line-ending = "lf";
            # rainbow-brackets = true;
            end-of-line-diagnostics = "hint";
            insert-final-newline = false;
            gutters = [
              "diff"
              "line-numbers"
              "spacer"
              "diagnostics"
            ];
            color-modes = true;
            bufferline = "always";
            completion-replace = false;

            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };

            file-picker = {
              hidden = true;
            };

            soft-wrap = {
              enable = true;
              wrap-at-text-width = false;
            };

            lsp = {
              display-inlay-hints = true;
              display-progress-messages = true;
            };

            statusline = {
              left = [
                "mode"
                "spinner"
                "read-only-indicator"
                "diagnostics"
              ];
              center = [ "file-name" ];
              right = [
                "version-control"
                "selections"
                "primary-selection-length"
                "total-line-numbers"
                "position"
                "file-encoding"
                "file-line-ending"
                "file-type"
              ];
              separator = "|";
              mode.normal = "NORMAL";
              mode.insert = "INSERT";
              mode.select = "SELECT";
            };

            whitespace = {
              render = {
                tab = "all";
              };
            };

            auto-save = {
              after-delay.enable = false;
              after-delay.timeout = 1000;
              focus-lost = true;
            };
          };
        };
        languages = {
          language-server = {
            # nil = {
            #   command = "nil";
            #   config = {
            #     formatting = {
            #       command = [ "alejandra" ];
            #     };
            #     nix = {
            #       maxMemoryMB = 16000;
            #       flake = {
            #         autoArchive = true;
            #         autoEvalInputs = true;
            #       };

            #     };
            #   };
            # };
            nixd = {
              command = "nixd";
              args = [ ];
              config.nixd = {
                nixpkgs = {
                  expr = "import ${inputs.nixpkgs} { }";
                };
                formatting = {
                  command = [ "alejandra" ];
                };
              };
            };
            pyright = {
              command = "pyright-langserver";
              args = [ "--stdio" ];
              config = { }; # <- this is the important line
            };
            rust-analyzer.config = {
              checkOnSave = true;
              cachePriming.enable = true;
              diagnostics.experimental.enable = true;
              check.features = "all";
              procMacro.enable = true;
              cargo.buildScripts.enable = true;
              imports.preferPrelude = true;
              serverPath = "${pkgs.ra-multiplex}/bin/ra-multiplex";
            };
          };

          language = [
            {
              name = "nix";
              language-servers = [
                "nixd"
                "nil"
              ];
              formatter.command = "alejandra";
              auto-format = true;
            }
          ];

          formatter = {
            black = {
              command = "black";
              args = [
                "-"
                "-q"
              ];
            };
            nixfmt = {
              command = "nixfmt";
            };
          };
        };
      };
    })
  ];
}
