# Copyright (c) 2019-2024, see AUTHORS. Licensed under MIT License, see LICENSE.

{ stdenv, fetchFromGitHub, autoreconfHook, makeWrapper, gnused,
  getopt, pandoc, termux-am }:

stdenv.mkDerivation rec {
  name = "termux-tools";
  version = "1.42.0";
  src = fetchFromGitHub {
    owner = "termux";
    repo = "termux-tools";
    rev = "v${version}";
    sha256 = "sha256-/Yif1EbexA+eyNlK2cHDkck6P4R9Kr7pYyfJu25mGOA=";
  };
  nativeBuildInputs = [ autoreconfHook makeWrapper pandoc ];
  propagatedInputs = [ termux-am ];
  # https://github.com/termux/termux-tools/pull/95
  patches = [ ./termux-tools.patch ];
  postPatch = ''
    substituteInPlace scripts/* --replace @TERMUX_APP_PACKAGE@/ com.termux.nix/
    substituteInPlace scripts/* --replace "getopt " "${getopt}/bin/getopt "
    ${gnused}/bin/sed -i 's|^am |${termux-am}/bin/am |' scripts/*
  '';
  postInstall = ''
    mv $out out-back
    mkdir -p $out/bin
    rm out-back/bin/termux-reset
    for script in out-back/bin/termux-*; do
        install $script $out/bin/
    done
  '';
}
