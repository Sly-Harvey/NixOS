## My reproducible system

![Screenshot](./assets/preview.png)

## Install


> [!IMPORTANT]
> The install script assumes that you have "hardware-configuration.nix" somewhere in /etc/nixos
> So please rename your file to that if it is named something else.
> This is only a concern if you use the install script!

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
```bash
sudo nixos-rebuild switch --flake .#nixos
```
