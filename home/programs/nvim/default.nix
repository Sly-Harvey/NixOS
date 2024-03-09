{ ... }:

{
    programs.neovim.enable = true;
    home.file.".config/nvim" = {
        source = builtins.fetchGit {
            url = "https://github.com/Sly-Harvey/nvim.git";
            ref = "performance";
            rev = "c2d87c81515261e7e3b0040e2e4b3a7b0a8c0544";
        };
        recursive = true;
    };
}
