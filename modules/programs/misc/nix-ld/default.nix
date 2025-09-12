{pkgs, lib, ...}: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.rocblas 
      rocmPackages.rocsparse 
      rocmPackages.rocrand
      rocmPackages.rocfft  
      rocmPackages.miopen  
      rocmPackages.rccl
      #libxcrypt
      libxcrypt-legacy
      zstd
      attr 
      bzip2
      acl
      libffi
      libsodium
      util-linux
      xz 
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      fuse
      fuse3
      gdk-pixbuf
      glib
      gtk3
      harfbuzz
      icu
      libGL
      libappindicator-gtk3
      libdrm
      libglvnd
      libnotify
      libpulseaudio
      libunwind
      libusb1
      libuuid
      libxkbcommon
      libxml2
      mesa
      nspr
      nss
      openssl
      pango
      pipewire
      python3
      stdenv.cc.cc
      systemd
      vulkan-loader
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      xorg.libxshmfence
      zlib
    ];
  };
  # environment.sessionVariables = {
  #     NIX_LD = pkgs.stdenv.cc.bintools.dynamicLinker;
  #     NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
  #       zstd zlib libxcrypt-legacy stdenv.cc.cc openssl libffi
  #       rocmPackages.clr.icd rocmPackages.rocblas rocmPackages.rocsparse
  #       rocmPackages.rocrand rocmPackages.rocfft rocmPackages.miopen rocmPackages.rccl
  #     ]);
  # };

}
