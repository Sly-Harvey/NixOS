{
  inputs,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        inputs.nixvim.packages.${system}.default
      ];
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
