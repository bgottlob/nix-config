{ pkgs, lib, ... }:

with pkgs;
let
  rstudioWithPkgs = rstudioWrapper.override {
    packages = with rPackages; [
      distill
      rio
      shiny
      tidyverse
    ];
  };
in
{
  home.packages = lib.optionals (!stdenv.hostPlatform.isDarwin) [ rstudioWithPkgs ];
}
