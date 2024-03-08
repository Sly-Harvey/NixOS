## My reproducible system

![Screenshot](./assets/preview.png)

## Install

### clone the repo
```bash
nix run --experimental-features "nix-command flakes" nixpkgs#git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
```
```bash
cd ~/NixOS
```
### then you can use the install script to install to /etc/nixos
```bash
sudo ./install.sh
```
### or you can build directly from the flake
> [!IMPORTANT]
> When building straight from the flake make sure to place your hardware-configuration.nix in nixos/hosts/
> and edit nixos/hosts/default.nix to import it.
> and CHANGE the user variable in flake.nix with your username!
> then run the command below
```bash
sudo nixos-rebuild switch --flake .#nixos
```
