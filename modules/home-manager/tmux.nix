{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = false;
    customPaneNavigationAndResize = true;
    focusEvents = true; # Lets neovim detect FocusGained to reload changed files
    keyMode = "vi";
    terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      set -s escape-time 0
    '';
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];
  };
}
