## My reproducible system

![Screenshot](./assets/preview.png)

> [!WARNING]
> **Not Tested on amd!**
> **I'm not responsible if your system breaks.**

## Install
### clone the repo
```bash
nix run --experimental-features "nix-command flakes" nixpkgs#git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
```
```bash
cd ~/NixOS
```
### then you can use the install script to install.
```bash
sudo ./install.sh
```
Make sure to reboot after.
### or you can build manually from the flake.
> [!IMPORTANT]
> When building manually from the flake make sure to place your hardware-configuration.nix in system/Default/
> and then CHANGE the username variable in flake.nix with your username!!
> then run the command below
```bash
sudo nixos-rebuild switch --flake .#nixos
```
