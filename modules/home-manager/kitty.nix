{ lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "Solarized_Dark_-_Patched";
    extraConfig = "enable_audio_bell no";
  };
}
