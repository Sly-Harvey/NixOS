## My reproducible system

![Screenshot](./assets/preview.png)

### To install run the commands in order below

```bash
nix run --experimental-features "nix-command flakes" nixpkgs#git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
```
```bash
cd ~/NixOS
```
```bash
sudo ./install.sh
```
