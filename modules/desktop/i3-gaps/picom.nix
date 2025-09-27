{
  services.picom = {
    enable = true;
    settings = {
      backend = "glx";
      glx-no-stencil = true;
      use-damage = true;
      xrender-sync-fence = true;
      vsync = true;
      refresh-rate = 0;
      detect-client-opacity = true;

      inactive-opacity = 0.7;
      active-opacity = 0.95;
      frame-opacity = 0.9;
      inactive-opacity-override = false;

      # Blur
      blur-background = true;
      blur = {
        method = "dual_kawase";
        strength = 3;
        size = 3; # Required for gaussian and box blur

        # strength = 6;
        # deviation = 1.0;
        # kernel = "11x11gaussian";
        # background = true;
        # background-frame = false;
        # background-fixed = false;
      };

      # blur-background-exclude = [
      #   "window_type = 'dock'"
      # ];

      # corner-radius = 5;
      # round-borders = 1;

      # Fading
      fading = false;
      fade-delta = 3;
      no-fading-openclose = false;

      # Dim inactive windows. (0.0 - 1.0)
      inactive-dim = 0.03;

      # Do not let dimness adjust based on window opacity.
      inactive-dim-fixed = true;

      # Do not let blur radius adjust based on window opacity.
      blur-background-fixed = true;

      # Can use name or class_g here
      opacity-rule = [
        "100:class_g = 'Rofi'"
        "100:class_g = 'zen'"
        "100:class_g = 'zen-beta'"
        "100:class_g = 'firefox'"
        "100:class_g = 'floorp'"
        "100:class_g = 'zen'"
        "100:class_g = 'Brave-browser'"
        "90:class_g = 'kitty' && focused"
        "90:class_g = 'Alacritty' && focused"
        "90:class_g = 'org.wezfurlong.wezterm' && focused"
        "80:name = 'Spotify' && !focused"
      ];
    };
  };
}
