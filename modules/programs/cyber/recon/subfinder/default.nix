{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ subfinder ];

      # Configuration for Subfinder saved to ~/.config/subfinder/config.yaml
      home.file.".config/subfinder/config.yaml".text = ''
        resolvers:
          - 1.1.1.1
          - 8.8.8.8
      '';
    })
  ];
}
