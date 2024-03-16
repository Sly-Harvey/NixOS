{username, ...}: {
  home-manager.users.${username} = _: {
    home.file.".config/swaylock/config".text = ''
      daemonize
      show-failed-attempts
      clock
      screenshot
      effect-blur=15x15
      effect-vignette=1:1
      color=1f1d2e80
      font="Inter"
      indicator
      indicator-radius=200
      indicator-thickness=20
      line-color=1f1d2e
      ring-color=191724
      inside-color=1f1d2e
      key-hl-color=eb6f92
      separator-color=00000000
      text-color=e0def4
      text-caps-lock-color=""
      line-ver-color=eb6f92
      ring-ver-color=eb6f92
      inside-ver-color=1f1d2e
      text-ver-color=e0def4
      ring-wrong-color=31748f
      text-wrong-color=31748f
      inside-wrong-color=1f1d2e
      inside-clear-color=1f1d2e
      text-clear-color=e0def4
      ring-clear-color=9ccfd8
      line-clear-color=1f1d2e
      line-wrong-color=1f1d2e
      bs-hl-color=31748f
      grace=2
      grace-no-mouse
      grace-no-touch
      datestr=%a, %B %e
      timestr=%I:%M %p
      fade-in=0.3
      ignore-empty-password
    '';

    programs.swaylock.enable = true;
    programs.wlogout.enable = true;
  };
}