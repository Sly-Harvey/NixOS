{ config, pkgs, inputs, zen-browser, ... }:
{
      environment.systemPackages = with pkgs; [
        inputs.zen-browser.packages."x86_64-linux".default

      ];
}
