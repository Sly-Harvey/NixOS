{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ dnsx ];

      # Configuration for dnsx saved to ~/.config/dnsx/config.yaml
      home.file.".config/dnsx/config.yaml".text = ''
        # Number of concurrent DNS queries
        threads: 50

        # Timeout in milliseconds
        timeout: 5000
      '';
    })
  ];
}
