{pkgs, terminal, ...}: {
  programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "kitty";
  services.gnome.sushi.enable = true;
  # Archive manager
  programs.file-roller = {
    enable = true;
    package = pkgs.file-roller;
  };
  services.tumbler.enable = true; # Thumbnail support for images
}
