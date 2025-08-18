{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ amass ];

      # Configuration for Amass saved to ~/.config/amass/config.ini
      home.file.".config/amass/config.ini".text = ''
        [settings]
        # Passive mode uses third-party APIs, good for stealth
        mode = passive

        # Resolver file path (optional, default is /etc/resolv.conf)
        dns_resolvers = /etc/resolv.conf
      '';
    })
  ];
}
