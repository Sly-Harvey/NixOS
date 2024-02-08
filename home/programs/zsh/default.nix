{ config, pkgs, ... }:

{
    home.file.".zshrc" = {
        source = ./.zshrc;
    };
    home.file.".zshenv" = {
        source = ./.zshenv;
    };
    home.file.".p10k.zsh" = {
        source = ./.p10k.zsh;
    };
    home.file.".powerlevel10k" = {
        source = ./.powerlevel10k;
        recursive = true;
    };
    home.file.".oh-my-zsh" = {
        source = ./.oh-my-zsh;
        recursive = true;
    };
}