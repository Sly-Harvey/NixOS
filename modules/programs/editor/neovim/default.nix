{ ...}: {
  home-manager.sharedModules = [
    (_: {
      programs.neovim.enable = true;
      home.file.".config/nvim" = {
        source = builtins.fetchGit {
          url = "https://github.com/Sly-Harvey/nvim.git";
          rev = "018aad196d833c441ded5b09a8f8e7546d0c1bf1";
        };
        recursive = true;
      };
    })
  ];
}
