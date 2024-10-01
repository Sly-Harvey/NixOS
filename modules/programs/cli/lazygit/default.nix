{
  pkgs,
  ...
}: let
  fromYAML = f: let
    jsonFile =
      pkgs.runCommand "lazygit yaml to attribute set" {nativeBuildInputs = [pkgs.jc];} # bash
      
      ''
        jc --yaml < "${f}" > "$out"
      '';
  in
    builtins.elemAt (builtins.fromJSON (builtins.readFile jsonFile)) 0;
in {
  home-manager.sharedModules = [
    (_: {
      home.shellAliases = {
        lg = "lazygit";
      };
      programs.lazygit = {
        enable = true;
        settings = {
          gui = fromYAML (
            pkgs.catppuccin + "/lazygit/themes/blue.yml"
          );
          git = {
            overrideGpg = true;
          };
        };
      };
    })
  ];
}
