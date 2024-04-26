{ pkgs, ... }:
{
  tmux-sessionizer = pkgs.callPackage ./tmux-sessionizer.nix {};
}
