{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      # While theHarvester isn't in home.packages, we still define its config file here
      home.file.".theHarvester/config.yaml".text = ''
        # Timeout for DNS queries
        dns_timeout: 5

        # Enable or disable Shodan integration
        use_shodan: true
      '';
    })
  ];

  # System-level install because theHarvester is not available in home-manager
  environment.systemPackages = with pkgs; [ theharvester ];
}
