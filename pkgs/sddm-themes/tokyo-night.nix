{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
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
}
