{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [ rust-analyzer ];
    plugins = with pkgs.vimPlugins; [
      auto-pairs
      csv-vim
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-vsnip
      nvim-cmp
      nvim-lspconfig
      rustaceanvim
      vim-vsnip
      vim-abolish
      vim-colors-solarized
      vim-elixir
      vim-erlang-runtime
      vim-javascript
      vim-json
      vim-markdown
      vim-nix
      vim-ruby
      vim-sleuth
      vim-slime
      vim-speeddating
      vim-surround
      vim-terraform
      vim-tmux-navigator
      vim-unimpaired
      vim-yaml
      vimtex
    ];
  };

  xdg.configFile = {
    "nvim/init.lua".text = ''
      vim.cmd [[source ${../../dotfiles/vimrc}]]
      require 'completion'
    '';

    "nvim/lua/completion.lua".source = ../../nvim/completion.lua;
  };
}
