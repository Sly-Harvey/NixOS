{ pkgs, ... }:
{
  tmux-find = pkgs.callPackage ./tmux-find.nix {};
}
