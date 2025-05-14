<h1 align="center">
   <img src="assets/nixos-logo.jxl" width="100px" /> 
   <br>
      My NixOS System
   <br>
      <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" /> <br>
   <div align="center">

   <div align="center">
      <p></p>
      <div align="center">
         <a href="https://github.com/Sly-Harvey/NixOS/stargazers">
            <img src="https://img.shields.io/github/stars/Sly-Harvey/NixOS?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6">
         </a>
         <a href="https://github.com/Sly-Harvey/NixOS/network/members">
            <img src="https://img.shields.io/github/forks/Sly-Harvey/NixOS?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=git&logoColor=C6A0F6" alt="GitHub Forks">
         </a>
         <!-- <a href="https://github.com/Sly-Harvey/NixOS/"> -->
         <!--    <img src="https://img.shields.io/github/repo-size/Sly-Harvey/NixOS?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6"> -->
         <!-- </a> -->
         <a = href="https://nixos.org">
            <img src="https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=91D7E3&label=NixOS&labelColor=303446&color=91D7E3">
            <!-- <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=303446&logo=NixOS&logoColor=white&color=91D7E3"> -->
         </a>
         <a href="https://github.com/Sly-Harvey/NixOS/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&"/>
         </a>
      </div>
      <br>
   </div>
</h1>

![Screenshot](assets/preview1.jxl)
![Screenshot](assets/preview2.jxl)
<details>
<summary>More Previews</summary>

![Screenshot](assets/preview3.jxl)
![Screenshot](assets/preview4.jxl)
![Screenshot](assets/preview5.jxl)

</details>

# Installation
> [!Note]
> <p>You should review the configuration variables in `flake.nix` before installing.<br>
> Also, check the imports at the top of `hosts/Default/configuration.nix`</p>
You can use the `install.sh` script while booted into a system or in the live installer.<br>
If you prefer the latter, you can obtain an ISO from [here](https://nixos.org/download/#nixos-iso).<br>
The minimal ISO is recommended, but you can use any.
```bash
git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
```
```bash
cd ~/NixOS
```
```bash
./install.sh
```

# Rebuilding
There are 4 ways to rebuild.<br>
1) Press **Super + U**.
2) Run `rebuild` in the terminal
3) Execute the `install.sh` script again.
4) Run `sudo nixos-rebuild switch --flake ~/NixOS#Default` if you installed from the live iso then use /etc/nixos#Default 

For a list of keybinds press **Super + ?** or **Super + Ctrl + K**

<details>
<summary>How to Use the Development Shells</summary>

- To initialise a new project from a template:
```bash
nix flake init -t ~/NixOS#NAME
```
- Alternatively, use the `new` keyword to create a new directory:
```bash
nix flake new -t ~/NixOS#NAME PROJECT_NAME
```
Replace `NAME` with any template defined in `dev-shells/default.nix`.<br>
These commands will generate a flake.nix and flake.lock file in your project directory.<br>
To enter the development shell:
- Use direnv if configured, or navigate to the project directory and run:
```bash
nix develop
```
</details> 

<!-- </details> -->
<!-- <summary>Credits/Inspiration</summary> -->

### Credits/Inspiration
| Credit                                                              |  Reason                                |
|---------------------------------------------------------------------|----------------------------------------|
| [Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots)          | Script and Waybar templates            |
| [HyDE](https://github.com/HyDE-Project/HyDE)                        | Some more useful scripts               |
| [rofi](https://github.com/adi1090x/rofi)                            | Rofi launcher templates                |
| [dev-templates](https://github.com/the-nix-way/dev-templates)       | Development templates                  |
| [Vimjoyer](https://www.youtube.com/@vimjoyer)                       | Short, simple, concise guides and info |

<!-- </details> -->

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
