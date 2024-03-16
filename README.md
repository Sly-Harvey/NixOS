<h1 align="center">
   <img src="./assets/nixos-logo.png  " width="100px" /> 
   <br>
      My reproducible system
   <br>
      <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" /> <br>
   <div align="center">

   <div align="center">
      <p></p>
      <div align="center">
         <a href="https://github.com/Sly-Harvey/NixOS/stargazers">
            <img src="https://img.shields.io/github/stars/Sly-Harvey/NixOS?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6">
         </a>
         <a href="https://github.com/Sly-Harvey/NixOS/">
            <img src="https://img.shields.io/github/repo-size/Sly-Harvey/NixOS?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6">
         </a>
         <a = href="https://nixos.org">
            <img src="https://img.shields.io/badge/NixOS-Stable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3">
            <!-- <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=303446&logo=NixOS&logoColor=white&color=91D7E3"> -->
         </a>
         <a href="https://github.com/Sly-Harvey/NixOS/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&"/>
         </a>
      </div>
      <br>
   </div>
</h1>

![Screenshot](./assets/preview.png)

> [!WARNING]
> <p>Not Tested on amd or bios!<br>

# Install
> [!Note]
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
