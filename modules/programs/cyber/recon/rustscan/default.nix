{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ rustscan ];

      # Configuration for RustScan saved to ~/.rustscan.toml
      home.file.".rustscan.toml".text = ''
        # Number of ports to scan in parallel (default: 4500 is aggressive but fast)
        batch_size = 4500

        # Timeout per scan attempt in milliseconds (1500ms = 1.5 seconds)
        timeout = 1500

        # Scan order: "Serial" (one at a time) or "Random"
        scan_order = "Serial"

        # Command to run when open ports are found - defaults to a basic Nmap scan
        command = ["-A", "-Pn", "-sC", "-sV"]
      '';
    })
  ];
}
