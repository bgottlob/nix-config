# Development and productivity tools for getting work done
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    jq
    yq
  ];

  home.file = {
    ".inputrc".source = ../../dotfiles/inputrc;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  imports = [
    ./k8s.nix
    ./kitty.nix
    ./neovim.nix
    ./rstudio.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
