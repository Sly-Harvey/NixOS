{ pkgs, lib, ... }:
let
  initLua = import ./plugins { inherit lib; };
in
{
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ trash-cli ];
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        initLua = initLua;
        plugins = {
          compress = pkgs.yaziPlugins.compress; # Compressing tool
          chmod = pkgs.yaziPlugins.chmod; # Permissions tool
          recycle-bin = pkgs.yaziPlugins.recycle-bin; # trash-cli integration
        };
        settings = {
          mgr = {
            show_hidden = true;
            show_symlink = true;
            sort_dir_first = true;
            linemode = "size"; # or size, permissions, owner, mtime
            ratio = [
              # or 0 3 4
              1
              3
              4
            ];
          };
          preview = {
            # wrap = "yes";
            tab_size = 4;
            image_filter = "triangle"; # from fast to slow but high quality: nearest, triangle, catmull-rom, lanczos3
            max_width = 1920; # maybe 1000
            max_height = 1080; # maybe 1000
            # max_width = 1500;
            # max_height = 1500;
            image_quality = 90;
          };
        };
        keymap = {
          mgr.prepend_keymap = [
            # recycle-bin plugin
            {
              on = [
                "R"
                "b"
              ];
              run = "plugin recycle-bin";
              desc = "Open Recycle Bin Menu";
            }

            # chmod plugin
            {
              on = [
                "R"
                "x"
              ];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }

            # compress plugin
            {
              on = [
                "<S-c>"
                "a"
              ];
              run = "plugin compress";
              desc = "Compress selected files";
            }
            {
              on = [
                "<S-c>"
                "p"
              ];
              run = "plugin compress -p";
              desc = "Compress selected files (password)";
            }
            {
              on = [
                "<S-c>"
                "h"
              ];
              run = "plugin compress -ph";
              desc = "Compress selected files (password+header)";
            }
            {
              on = [
                "<S-c>"
                "l"
              ];
              run = "plugin compress -l";
              desc = "Compress selected files (compression level)";
            }
            {
              on = [
                "<S-c>"
                "u"
              ];
              run = "plugin compress -phl";
              desc = "Compress selected files (password+header+level)";
            }

            {
              on = "q";
              run = "close";
            }
            {
              on = [ "e" ];
              run = "open";
            }
            # {
            #   on = [ "d" ];
            #   run = "remove --force";
            # }
            {
              on = [
                "g"
                "D"
              ];
              run = "cd ~/Documents";
            }
            {
              on = [
                "g"
                "p"
              ];
              run = "cd /mnt/work/Projects";
            }
            {
              on = [
                "g"
                "P"
              ];
              run = "cd /mnt/games/Windows/Pirate";
            }
          ];
        };
        theme = {
          mgr = {
            border_symbol = " ";
          };
          status = {
            separator_open = "";
            separator_close = "";
          };
        };
      };
    })
  ];
}
