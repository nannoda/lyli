{ pkgs, lib, config, inputs, ... }:

let
  # Fetch and build libusbpp from GitHub
  libusbpp = pkgs.stdenv.mkDerivation {
    pname = "libusbpp";
    version = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "nannoda";
      repo = "libusbpp";
      rev = "298e9d46140a651d6fc4c6131005b23d470b45f7"; # specific commit
      sha256 = "1rz22amp0l6x51qxvyja47rca94pjxjq00kqa7skjybflnfkvd8z"; # calculated SHA
    };

    nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake pkgs.ninja ]; # Use ninja instead of make
    buildInputs = [ pkgs.libusb1 ];

    buildPhase = ''
    rm -rf build CMakeCache.txt CMakeFiles

      rm -rf build
      mkdir -p build
      cd build

      # Use Ninja to generate build files
      cmake -G Ninja -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_PREFIX=$out ..
      ninja # Use ninja to build
    '';

    installPhase = ''
      cd build
      ninja install # Use ninja to install
      # Ensure the pkgconfig directory exists
      mkdir -p $out/lib/pkgconfig

      # Copy pkg-config file if it exists
      if [ -f ../usbpp.pc ]; then
        cp ../usbpp.pc $out/lib/pkgconfig/
      fi
    '';

    meta = with lib; {
      description = "Simple C++ wrapper around libusb";
      license = licenses.lgpl3;
    };
  };
in {
  packages = [
    pkgs.libusb1
    pkgs.jsoncpp
    pkgs.opencv
    pkgs.opencv4
    pkgs.tbb
    pkgs.qt5.qtbase
    libusbpp # Add libusbpp to the environment
  ];

  languages.cplusplus.enable = true;
}
