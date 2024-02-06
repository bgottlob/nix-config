{ config, pkgs, ... }:

let
  vimrcSrc = builtins.readFile ../../dotfiles/vimrc;

  vimPlugins = with pkgs.vimPlugins; [
    auto-pairs
    csv-vim
    vim-abolish
    vim-colors-solarized
    vim-elixir
    vim-erlang-runtime
    vim-javascript
    vim-json
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

  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
  {
    # Keep vim lighter than neovim
    programs.vim = {
      enable = true;
      defaultEditor = true;
      extraConfig = vimrcSrc;
      plugins = vimPlugins;
    };

    programs.neovim = {
      enable = true;
      extraConfig = vimrcSrc;

      extraPackages = with pkgs; [
        cargo
        rust-analyzer
      ];

      extraLuaConfig = ''
        --[[
          When in normal mode, the key sequence space-e-x will open netrw
        ]]--
        vim.g.mapleader = " "
        -- "n" for normal mode
        -- the vim command :Ex (or :Explore) opens netrw
        vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)
      '';

      plugins = with pkgs.vimPlugins; [
        markdown-preview-nvim
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.rust
          ]));
          config = toLuaFile ../../dotfiles/nvim/plugins/treesitter.lua;
        }
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ../../dotfiles/nvim/plugins/lspconfig.lua;
        }
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        luasnip
        friendly-snippets
      ] ++ vimPlugins;
    };
  }
