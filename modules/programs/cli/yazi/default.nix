{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
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
            {
              on = [ "e" ];
              run = "open";
            }
            {
              on = [ "d" ];
              run = "remove --force";
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
