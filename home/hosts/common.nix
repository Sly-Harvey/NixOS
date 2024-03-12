{
  pkgs,
  ...
}: {
  imports = [
    ../programs/nixvim
    ../programs/alacritty
    ../programs/direnv
    ../programs/lf
    ../programs/firefox
    ../programs/vscode
    ../programs/mpv
    ../programs/zsh
    ../wallpapers
    ../themes
  ];
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (pkgs.writeShellScriptBin "hello" ''
      echo "Hello World!"
    '')
  ];
  home.file.".local/bin/" = {
    source = ../scripts;
    recursive = true;
  };
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  programs.home-manager.enable = true;
}
