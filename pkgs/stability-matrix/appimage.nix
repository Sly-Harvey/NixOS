{ lib, pkgs, srcInfo }:

let
  inherit (srcInfo) version sha256;

  # Fetch the raw ZIP with a flat file hash (easy to prefetch)
  zipSrc = pkgs.fetchurl {
    url = "https://github.com/LykosAI/StabilityMatrix/releases/download/v${version}/StabilityMatrix-linux-x64.zip";
    inherit sha256;  # base32 or SRI both fine
  };

  # Unzip to get the AppImage file in the store
  extracted = pkgs.runCommand "stability-matrix-${version}-unzipped" { buildInputs = [ pkgs.unzip ]; } ''
    set -euo pipefail
    mkdir -p $out
    cd $out
    unzip -qq "${zipSrc}"
    # the zip contains StabilityMatrix.AppImage at the top level
    if [ ! -f "StabilityMatrix.AppImage" ]; then
      echo "StabilityMatrix.AppImage not found after unzip" >&2
      ls -la
      exit 1
    fi
    chmod +x StabilityMatrix.AppImage
  '';

  appImage = "${extracted}/StabilityMatrix.AppImage";
in
pkgs.appimageTools.wrapType2 {
  pname = "stability-matrix";
  inherit version;
  src = appImage;

  # Common runtime libs for Avalonia/.NET AppImages on NixOS
  extraPkgs = p: with p; [
    zlib glibc icu libxcrypt-legacy openssl cacert
    libGL libglvnd mesa fontconfig freetype
    xorg.libX11 xorg.libXext xorg.libXcursor xorg.libXi
    xorg.libXrandr xorg.libXtst
    dbus dbus-glib curl
  ];

  meta = with lib; {
    description = "Multi-platform package manager & inference UI for Stable Diffusion";
    homepage = "https://github.com/LykosAI/StabilityMatrix";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
