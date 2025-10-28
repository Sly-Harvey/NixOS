{
  inputs,
  host,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        inherit (import ../../../../hosts/${host}/variables.nix) terminal;
        nixvim-package = inputs.nixvim.packages.${pkgs.system}.default;

        extended-nixvim =
          if config.stylix.targets.nixvim.enable then
            # For nixos-unstable
            nixvim-package.extend config.stylix.targets.nixvim.exportedModule

            # for nixos-25.05 (Deprecated by 26.11)
            # nixvim-package.extend config.lib.stylix.nixvim.config
          else
            nixvim-package;
      in
      {
        home.packages = with pkgs; [
          extended-nixvim
          # inputs.nixvim.packages.${system}.default
        ];
        xdg.desktopEntries = {
          "nvim" = {
            name = "Neovim wrapper";
            genericName = "Text Editor";
            comment = "Edit text files";
            exec = "${pkgs.${terminal}}/bin/${terminal} --class \"nvim-wrapper\" -e nvim %F";
            icon = "nvim";
            mimeType = [
              "text/plain"
              "text/x-makefile"
            ];
            categories = [
              "Development"
              "TextEditor"
            ];
            terminal = false; # Important: set to false since we're calling kitty directly
          };
        };
      }
    )
  ];
}
