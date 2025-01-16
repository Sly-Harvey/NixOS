{...}: {
  environment.variables."DIRENV_WARN_TIMEOUT" = "60s";
  home-manager.sharedModules = [
    (_: {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };
      # home.sessionVariables = {
      #   # DIRENV_DIR = "/tmp/direnv";
      #   # DIRENV_CACHE = "/tmp/direnv-cache"; # Optional, for caching
      # };
    })
  ];
}
