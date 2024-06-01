# Copyright (c) 2019-2022, see AUTHORS. Licensed under MIT License, see LICENSE.

{ pkgs, ... }:

let
  termux-am = pkgs.callPackage (import ../../pkgs/am/termux-am.nix) {};
  termux-tools = pkgs.callPackage (import ../../pkgs/am/termux-tools.nix) {
    inherit termux-am;
  };
in
{
  config = {
    environment.packages = [ termux-am termux-tools ];
  };
}
