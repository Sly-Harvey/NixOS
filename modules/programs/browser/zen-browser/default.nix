{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [inputs.zen-browser.packages.${system}.default];
}
