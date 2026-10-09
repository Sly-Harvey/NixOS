{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    ludusavi
    godot
    proton-vpn
    github-desktop
    antigravity-cli
    # pokego # Overlayed

    # All-in-one front-end for emulators 
    (retroarch.withCores (cores: with cores; [
      # citra # Nintendo - 3DS
      dolphin # Nintendo - GameCube / Wii
      # fbneo # Arcade
      flycast # Sega - Dreamcast / Naomi
      genesis-plus-gx # Sega - MS/GG/MD/CD
      mame # Arcade
      melonds # Nintendo - DS
      mgba # Nintendo - Game Boy Advance
      mupen64plus # Nintendo - N64
      pcsx2 # Sony - PlayStation 2
      ppsspp # Sony - PlayStation Portable (PSP)
      picodrive # Sega - MD/32X
      prosystem # Atari - 7800 / 2600
      sameboy # Nintendo - Game Boy / Color
      snes9x # Nintendo - SNES / SFC
      swanstation # Sony - PlayStation
    ]))
  ];
}
