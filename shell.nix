{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, pythonPackages ? pkgs.python3Packages
}: let
  inherit (pythonPackages) pybind11;
  pybind11_json = stdenv.mkDerivation {
    pname = "pybind11_json";
    version = "0.2.13";
    src = pkgs.fetchFromGitHub {
      owner = "pybind";
      repo = "pybind11_json";
      rev = "0.2.13";
      sha256 = "sha256-Kl/QflV2bBoH72/LW03K8JDlhBF+DYYXL47A5s1nmTw=";
    };
    nativeBuildInputs = [ pkgs.cmake pkgs.ninja ];
    buildInputs = [ pybind11 pkgs.nlohmann_json ];
  };
in pkgs.mkShell {
  buildInputs = [
    pythonPackages.pytest
    pkgs.llvmPackages_latest.bintools
    pkgs.cmake
    pkgs.ninja
    pkgs.ccache
    pkgs.conan
    pkgs.boost
    pkgs.symengine
    pkgs.libmpc # looks like this should be a propagated dep of symengine
    pkgs.eigen
    pkgs.nlohmann_json
    pkgs.gmp
    pkgs.flint
    pkgs.catch2_3 # catch2 failed missing cmake target Catch2Catch2WithMain
    pkgs.rapidcheck
    pybind11
    pybind11_json
  ];
}
