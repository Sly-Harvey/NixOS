{
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            # "FiraCode"
          ];
        })
      ];

      programs.alacritty = {
        enable = true;
        settings = {
          colors = {
            draw_bold_text_with_bright_colors = true;
            #primary = {
            #  background = "0x1f1f28";
            #  foreground = "0xdcd7ba";
            #};
            normal = {
              black = "0x090618";
              blue = "0x7e9cd8";
              cyan = "0x6a9589";
              green = "0x76946a";
              magenta = "0x957fb8";
              red = "0xc34043";
              white = "0xc8c093";
              yellow = "0xc0a36e";
            };
            bright = {
              black = "0x727169";
              blue = "0x7fb4ca";
              cyan = "0x7aa89f";
              green = "0x98bb6c";
              magenta = "0x938aa9";
              red = "0xe82424";
              white = "0xdcd7ba";
              yellow = "0xe6c384";
            };
            selection = {
              background = "0x2d4f67";
              foreground = "0xc8c093";
            };
          };

          font = {
            size = 11.0;
            normal = {
              family = "JetBrainsMono Nerd Font";
              style = "Regular";
            };
            bold = {
              family = "JetBrainsMono Nerd Font";
              style = "Bold";
            };

            bold_italic = {
              family = "JetBrainsMono Nerd Font";
              style = "Bold Italic";
            };

            italic = {
              family = "JetBrainsMono Nerd Font";
              style = "Italic";
            };
          };

          window = {
            decorations = "full";
            dynamic_padding = false;
            opacity = 0.6;
            startup_mode = "Maximized";

            padding.x = 0;
            padding.y = 0;
            dimensions.columns = 100;
            dimensions.lines = 30;
            class.general = "Alacritty";
            class.instance = "Alacritty";
          };

          shell = {
            program = "${pkgs.zsh}/bin/zsh";
          };

          keyboard.bindings = [
            /*
               {
              chars = "lf\r";
              key = "L";
              mods = "Control|Alt";
            }
            */
            {
              chars = "cd $(${pkgs.fd}/bin/fd . /mnt/seagate /mnt/seagate/dev/ /run /run/current-system ~/.local/ ~/ --max-depth 2 | fzf)\r";
              key = "F";
              mods = "Control";
            }
            {
              chars = "tmux-sessionizer\r";
              key = "T";
              mods = "Control";
            }
            {
              action = "Paste";
              key = "Y";
              mods = "Control";
            }
            {
              action = "Copy";
              key = "W";
              mods = "Alt";
            }
            {
              action = "SpawnNewInstance";
              key = "Return";
              mods = "Super|Shift";
            }
          ];

          selection = {
            save_to_clipboard = false;
            semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
          };

          scrolling = {
            history = 10000;
            multiplier = 3;
          };
        };
      };
    })
  ];
}
