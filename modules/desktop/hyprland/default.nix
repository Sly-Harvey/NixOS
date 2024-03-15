{
  home-manager,
  username,
  ...
}: {
  home-manager.users.${username} = _: {
    imports = [
      ./hypr
      ./waybar
      ./wlogout
      ./rofi
      ./dunst
      ./swaylock
      ./swaync
    ];
  };
}
