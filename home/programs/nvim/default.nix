{ config, pkgs, ... }:

{
    programs.neovim.enable = true;
    home.file.".config/nvim" = {
        source = builtins.fetchGit {
            url = "https://github.com/Sly-Harvey/nvim.git";
            rev = "c0358a6ea85d64d785746a66afdd67c7ecea3d57";
        };
        recursive = true;
    };
}