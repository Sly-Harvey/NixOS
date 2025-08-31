{inputs, pkgs, ...}: {
  environment.systemPackages = with pkgs; [zig] # Required
  home-manager.sharedModules = [
    (_: {
      programs.neovim.enable = true;
      xdg.configFile."nvim".source = inputs.neovim;
      xdg.desktopEntries = {
        "nvim" = {
          name = "Neovim wrapper";
          genericName = "Text Editor";
          comment = "Edit text files";
          exec = "${pkgs.kitty}/bin/kitty --class \"nvim-wrapper\" -e nvim %F";
          icon = "nvim";
          mimeType = [
            "text/plain"
            "text/x-makefile"
          ];
          categories = ["Development" "TextEditor"];
          terminal = false; # Important: set to false since we're calling kitty directly
        };
      };
    })
  ];
}
