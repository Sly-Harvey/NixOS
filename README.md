## My reproducible system

![Screenshot](./assets/preview.png)

> [!WARNING]
> <p>Not Tested on amd or bios!<br>

# Install
> [!IMPORTANT]
> <p>Default locale and timezone is British.<br>
> If you want to change this then edit the variables in flake.nix.</p>

Make sure to reboot after installing with any of the methods below.
## Using the install script
```bash
nix run --experimental-features "nix-command flakes" nixpkgs#git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
```
```bash
cd ~/NixOS
```
```bash
sudo ./install.sh
```
Make sure to reboot after.
## Building manually
> [!IMPORTANT]
> <p>When building manually from the flake make sure to place your hardware-configuration.nix in hosts/Default/<br>
> and CHANGE the username variable in flake.nix with your username!!<br>
> then run the command below</p>
```bash
sudo nixos-rebuild switch --flake .#nixos
```
