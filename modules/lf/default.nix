{
  username,
  ...
}: {
  home-manager.users.${username} = _: {
    home.file.".config/lf/lfrc".source = ./lfrc;
    home.file.".config/lf/lfcd.sh".source = ./lfcd.sh;
    home.file.".config/lf/lf_kitty_clean".source = ./lf_kitty_clean;
    home.file.".config/lf/lf_kitty_preview".source = ./lf_kitty_preview;
  };
}
