{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rgbds
  ];

  home.file.".config/nvim/syntax/rgbasm.vim" = {
    source = ../../dotfiles/nvim/syntax/rgbasm.vim;
  };

  home.file.".vim/syntax/rgbasm.vim" = {
    source = ../../dotfiles/vim/syntax/rgbasm.vim;
  };
}
