{
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    (_: {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
          obs-vkcapture
          obs-pipewire-audio-capture
        ];
      };
    })
  ];
}
