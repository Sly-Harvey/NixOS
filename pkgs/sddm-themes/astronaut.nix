{
  stdenv,
  fetchFromGitHub,
  kdePackages,
  theme ? "astronaut",
}:
stdenv.mkDerivation rec {
  pname = "sddm-astronaut-theme";
  version = "5e39e0841d4942757079779b4f0087f921288af6";
  dontBuild = true;
  dontWrapQtApps = true;
  # Required Qt6 libraries for SDDM >= 0.21
  propagatedBuildInputs = with kdePackages; [
    qtsvg
    qtmultimedia
    qtvirtualkeyboard
  ];
  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "${version}";
    sha256 = "09vi9dr0n0bhq8cj4jq1h17jw2ssi79zi9lhn0j6kgbxrqk2g8vf";
  };
  buildPhase = ''
    runHook preBuild
    echo "No build required."
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install theme to a single directory
    install -dm755 "$out/share/sddm/themes/sddm-astronaut-theme"
    cp -r ./* "$out/share/sddm/themes/sddm-astronaut-theme"

    # Copy fonts system-wide
    install -dm755 "$out/share/fonts"
    cp -r "$out/share/sddm/themes/sddm-astronaut-theme/Fonts/." "$out/share/fonts"

    # Update metadata.desktop to load the chosen subtheme
    metaFile="$out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
    if [ -f "$metaFile" ]; then
      substituteInPlace "$metaFile" \
        --replace "ConfigFile=Themes/astronaut.conf" "ConfigFile=Themes/${theme}.conf"
    fi
    substituteInPlace "$out/share/sddm/themes/sddm-astronaut-theme/Themes/black_hole.conf" \
      --replace "ScreenPadding=\"5\"" "ScreenPadding=\"\""
    substituteInPlace "$out/share/sddm/themes/sddm-astronaut-theme/Themes/astronaut.conf" \
      --replace "PartialBlur=\"true\"" "PartialBlur=\"false\""
    substituteInPlace "$out/share/sddm/themes/sddm-astronaut-theme/Themes/purple_leaves.conf" \
      --replace "PartialBlur=\"true\"" "PartialBlur=\"false\""
     runHook postInstall
  '';

  # Propagate Qt6 libraries to user environment
  postFixup = ''
    mkdir -p $out/nix-support
    echo ${kdePackages.qtsvg} >> $out/nix-support/propagated-user-env-packages
    echo ${kdePackages.qtmultimedia} >> $out/nix-support/propagated-user-env-packages
    echo ${kdePackages.qtvirtualkeyboard} >> $out/nix-support/propagated-user-env-packages
  '';
}
