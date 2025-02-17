{ config, pkgs, inputs, zen-browser, ... }:
{
      environment.systemPackages = with pkgs; [
        zen-browser

      ];
}
