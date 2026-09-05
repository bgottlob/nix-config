{ lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "Solarized_Dark_-_Patched";
    font.name = "Hack Nerd Font";
    extraConfig = "enable_audio_bell no";
  };
}
