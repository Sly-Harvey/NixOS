{
  inputs,
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = _: {
    home.packages = with pkgs; [
      inputs.nixvim.packages.${system}.default
    ];
  };
}
