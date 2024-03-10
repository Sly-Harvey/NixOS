{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    nix
    home-manager
    figlet
    lolcat
  ];
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  # shellHook =
  # ''
  #   echo "BUILDING!" | figlet -W | lolcat -F 0.3 -p 2.5 -S 300
  # '';
}
