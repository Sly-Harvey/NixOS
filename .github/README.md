<h1 align="center">
   <img src="assets/nixos-logo.png" width="100px" /> 
   <br>
      My NixOS system
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
            <img src="https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3">
            <!-- <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=303446&logo=NixOS&logoColor=white&color=91D7E3"> -->
         </a>
         <a href="https://github.com/Sly-Harvey/NixOS/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&"/>
         </a>
      </div>
      <br>
   </div>
</h1>

![Screenshot](assets/preview1.png)
![Screenshot](assets/preview2.png)
<details>
<summary>More Previews</summary>

![Screenshot](assets/preview3.png)
![Screenshot](assets/preview4.png)
![Screenshot](assets/preview5.png)

</details>

# Installation
> [!Note]
> <p>You should review the configuration variables in flake.nix before installing.<br>
> Also check out the imports at the top of hosts/Default/configuration.nix</p>
<!-- ## Using the install script -->
```bash
nix run --experimental-features "nix-command flakes" nixpkgs#git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
```
```bash
cd ~/NixOS
```
```bash
./install.sh
```
For a list of keybinds press Super + ? or Super + Ctrl + K
<details>
<summary>How to use the dev-shells</summary>

```bash
nix flake init -t ~/NixOS#NAME
```
or use the "new" keyword to initialise a new directory
```bash
nix flake new -t ~/NixOS#NAME PROJECT_NAME
```
where NAME is any of the templates defined in dev-shells/default.nix
</details>

<details>
<summary>Star History</summary>
<a href="https://github.com/Sly-Harvey/NixOS/stargazers">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Sly-Harvey/NixOS&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Sly-Harvey/NixOS&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Sly-Harvey/NixOS&type=Date" />
 </picture>
</a>
</details>

### Credits/Inspiration
| Credit                                                              |  Reason                                |
|---------------------------------------------------------------------|----------------------------------------|
| [Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots)          | Script and Waybar templates            |
| [HyDE](https://github.com/HyDE-Project/HyDE)                        | Some more useful scripts               |
| [Rofi](https://github.com/adi1090x/rofi)                            | Rofi launcher templates                |
| [VimJoyer](https://www.youtube.com/@vimjoyer)                       | Short, simple, concise guides and info |
