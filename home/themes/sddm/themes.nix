{
  stdenv,
  fetchFromGitHub,
}: {
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
