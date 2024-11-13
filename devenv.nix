{ pkgs, lib, config, inputs, ... }:

{
  packages = [
    pkgs.libusb1
    # pkgs.libusbp
    pkgs.jsoncpp
    pkgs.opencv
    pkgs.opencv4
    pkgs.tbb
    pkgs.libusb1
    pkgs.qt5.qtbase
  ];

  # https://devenv.sh/languages/
  languages.cplusplus.enable = true;
}
