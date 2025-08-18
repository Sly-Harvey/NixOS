{ pkgs, ... }: {
  # This sharedModule allows us to include this config via home-manager.sharedModules
  home-manager.sharedModules = [
    (_: {
      # Summon the nmap binary via Nix
      home.packages = with pkgs; [ nmap ];
    })
  ];
}