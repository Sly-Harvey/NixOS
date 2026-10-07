{ pkgs, ... }:
let
  fromYAML =
    f:
    let
      jsonFile =
        pkgs.runCommand "lazygit yaml to attribute set" { nativeBuildInputs = [ pkgs.jc ]; } # bash

          ''
            jc --yaml < "${f}" > "$out"
          '';
    in
    builtins.elemAt (builtins.fromJSON (builtins.readFile jsonFile)) 0;
in
{
  home-manager.sharedModules = [
    (_: {
      home.shellAliases = {
        lg = "lazygit";
      };
      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
            mouseEvents = false;

            # Catppuccin Mocha with Blue Accent
            theme = {
              authorColors = {
                "*" = "#b4befe";
              };
              activeBorderColor = [
                "#89b4fa"
                "bold"
              ];
              inactiveBorderColor = [
                "#a6adc8"
              ];
              optionsTextColor = [
                "#89b4fa"
              ];
              selectedLineBgColor = [
                "#313244"
              ];
              cherryPickedCommitBgColor = [
                "#45475a"
              ];
              cherryPickedCommitFgColor = [
                "#89b4fa"
              ];
              unstagedChangesColor = [
                "#f38ba8"
              ];
              defaultFgColor = [
                "#cdd6f4"
              ];
              searchingActiveBorderColor = [
                "#f9e2af"
              ];
            };
          };
          # gui.theme = fromYAML (
          #   pkgs.fetchFromGitHub {
          #     owner = "catppuccin";
          #     repo = "lazygit";
          #     rev = "c24895902ec2a3cb62b4557f6ecd8e0afeed95d5";
          #     hash = "sha256-4eJEOEfwLBc4EoQ32TpuhXS3QDvQ8FtT7EgpotEKV7o=";
          #   }
          #   + "/themes/mocha/blue.yml"
          # );
          git = {
            overrideGpg = true;
          };
        };
      };
    })
  ];
}
