{ config, pkgs, ... }:

{
  ids.gids.nixbld = 101;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users."brandon.gottlob" = {
    name = "brandon.gottlob";
    home = "/Users/brandon.gottlob";
  };

  home-manager.users."brandon.gottlob" = {
    imports = [
      ./home.nix
      ../../modules/home-manager/workstation.nix
    ];
  };
}
