{ config, pkgs, ... }: {
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        wordlistsPkg = pkgs.wordlists.override {
          lists = with pkgs; [
            nmap
            seclists
            rockyou
            wfuzz
          ];
        };
      in {
        home.packages = [ wordlistsPkg ];

        home.file = {
            "wordlists/rockyou.txt".source = "${wordlistsPkg}/share/wordlists/rockyou.txt";
            "wordlists/seclists".source = "${wordlistsPkg}/share/wordlists/seclists";
            "wordlists/wfuzz".source = "${wordlistsPkg}/share/wordlists/wfuzz";
            "wordlists/nmap.lst".source = "${wordlistsPkg}/share/wordlists/nmap.lst";
        };
      }
    )
  ];

  imports = [
    ./dirb
    ./sqlmap
    # ./cewl
    # ./crunch
  ];
}
