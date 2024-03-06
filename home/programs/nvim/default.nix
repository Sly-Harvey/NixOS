{ config, pkgs, ... }:

{
    programs.neovim.enable = true;
    home.file.".config/nvim" = {
        source = builtins.fetchGit {
            url = "https://github.com/Sly-Harvey/nvim.git";
            rev = "afd114996c8c1713d5e06ba32569b544b2929dd6";
        };
        recursive = true;
    };
}
