{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
}:
stdenvNoCC.mkDerivation rec {
  pname = "nightfox-gtk-theme";
  version = "unstable-2022-12-09";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Nightfox-GTK-Theme ";
    rev = "a8b01a28f2d1d9dd57d98d3708602b0d72340338";
    sha256 = "sha256-00000000000000000000000";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Gtk theme based on the Gruvbox colour pallete";
    homepage = "https://www.pling.com/p/1681313/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.math-42 ];
  };
}