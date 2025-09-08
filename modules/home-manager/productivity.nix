{ pkgs, ... }:

{
  home.packages = with pkgs; [
    keepassxc
    libreoffice-qt
    logseq
    thunderbird
  ];
}

