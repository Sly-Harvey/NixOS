{
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    (_: {
      programs.emacs = {
        enable = true;
        package = pkgs.emacs.override {
          withGTK3 = true;
          withGTK2 = false;
          withPgtk = true; # true on wayland
          withNativeCompilation = true;
          withTreeSitter = true;
        };
      };
      services.emacs = {
        enable = true;
        package = pkgs.emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
      };
    })
  ];
}
