{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.nixvim.packages.${system}.default
  ];
}
