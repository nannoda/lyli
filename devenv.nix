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

    nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake pkgs.makeWrapper pkgs.libusb1 ];
    buildInputs = [ pkgs.libusb1 ];

    buildPhase = ''
      # Remove any existing build directory to ensure a fresh configuration
      rm -rf build
      mkdir build
      cd build

      # Run CMake with verbose output and debugging information
      cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_PREFIX=$out ..

      # Verbose build to capture more details
      make VERBOSE=1
    '';

    installPhase = ''
      cd build
      make install

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
