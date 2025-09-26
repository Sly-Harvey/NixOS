{
  pkgs,
  inputs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix)
    username
    editor
    terminal
    browser
    shell
    ;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  programs.dconf.enable = true; # Enable dconf for home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${username} = {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      xdg.enable = true;
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "23.11"; # Do not change!
        sessionVariables = {
          EDITOR = "${editor}";
          BROWSER = "${browser}";
          TERMINAL = "${terminal}";
        };
      };
    };
  };
  # programs.zsh.enable = true; # TODO: REMOVE THIS LINE
  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # sudo access
        "input"
        "networkmanager"
        "video"
        "audio"
        "libvirtd"
        "kvm"
        "docker"
        "disk"
        "adbusers"
        "lp"
        "scanner"
        "vboxusers" # Virtual Box
      ];
      shell = pkgs.${shell};
      ignoreShellProgramCheck = true;
    };
  };
  nix.settings.allowed-users = [ "${username}" ];
}
