{
  stdenv,
  fetchFromGitHub,
  pkgs,
  theme ? "astronaut",
}: {
  astronaut = stdenv.mkDerivation rec {
    pname = "sddm-astronaut-theme";
    version = "5e39e0841d4942757079779b4f0087f921288af6";
    dontBuild = true;
    dontWrapQtApps = true;
    # Required Qt6 libraries for SDDM >= 0.21
    propagatedBuildInputs = with pkgs.kdePackages; [
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
      echo ${pkgs.kdePackages.qtsvg} >> $out/nix-support/propagated-user-env-packages
      echo ${pkgs.kdePackages.qtmultimedia} >> $out/nix-support/propagated-user-env-packages
      echo ${pkgs.kdePackages.qtvirtualkeyboard} >> $out/nix-support/propagated-user-env-packages
    '';
  };
  /*
     astronaut = stdenv.mkDerivation rec {
    pname = "sddm-astronaut-theme";
    version = "468a100460d5feaa701c2215c737b55789cba0fc";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/astronaut
    '';
    src = fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "${version}";
      sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
    };
  };
  */
  sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "v1.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };
  tokyo-night = stdenv.mkDerivation rec {
    pname = "sddm-tokyo-night-theme";
    version = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/tokyo-night
    '';
    src = fetchFromGitHub {
      owner = "siddrs";
      repo = "tokyo-night-sddm";
      rev = "${version}";
      sha256 = "1gf074ypgc4r8pgljd8lydy0l5fajrl2pi2avn5ivacz4z7ma595";
    };
  };
}
