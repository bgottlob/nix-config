{ config, pkgs, ... }:

let
  vimrcSrc = (builtins.readFile ../../dotfiles/vimrc) + ''
    highlight Normal ctermbg=none
  '';

  nvimrcSrc = (builtins.readFile ../../dotfiles/vimrc) + ''
    highlight Normal ctermbg=none guibg=none
  '';

  vimPlugins = with pkgs.vimPlugins; [
    auto-pairs
    vim-abolish
    vim-sleuth
    vim-slime
    vim-speeddating
    vim-surround
    vim-tmux-navigator
    vim-unimpaired
  ];

  vimSyntaxPlugins = with pkgs.vimPlugins; [
    csv-vim
    vim-elixir
    vim-javascript
    vim-json
    vim-nix
    vim-ruby
    vim-terraform
    vim-yaml
    vimtex
  ];

  toLuaStr = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
  {
    # Keep vim lighter than neovim
    programs.vim = {
      enable = true;
      defaultEditor = true;
      extraConfig = vimrcSrc;
      plugins = vimPlugins ++ vimSyntaxPlugins ++ [
        pkgs.vimPlugins.vim-colors-solarized
      ];
    };

    programs.neovim = {
      enable = true;
      extraConfig = nvimrcSrc;

      extraPackages = with pkgs; [
        # Rust
        cargo
        rust-analyzer
        rustc

        # Elixir
        elixir-ls
      ];

      plugins = with pkgs.vimPlugins; [
        nvim-solarized-lua
        # Treesitter and syntax highlighting
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.csv
            p.elixir
            p.erlang
            p.heex
            p.javascript
            p.json
            p.latex
            p.lua
            p.markdown
            p.nix
            p.ruby
            p.rust
            p.terraform
            p.toml
            p.yaml
          ]));
          config = toLuaFile ../../dotfiles/nvim/plugins/treesitter.lua;
        }

        # LSP, snippet, and autocompletion plugins
        {
          plugin = nvim-lspconfig;
          config = (
            (toLuaFile ../../dotfiles/nvim/plugins/lspconfig.lua) + (
              toLuaStr ''
                require'lspconfig'.elixirls.setup{
                  cmd = { "${pkgs.elixir-ls}/bin/elixir-ls" };
                }
              ''
            )
          );
        }
        cmp-nvim-lsp
        cmp_luasnip
        friendly-snippets
        luasnip
        nvim-cmp

        # Fuzzy finder
        plenary-nvim # Dependency of telescope
        {
          plugin = telescope-nvim;
          config = toLuaFile ../../dotfiles/nvim/plugins/telescope.lua;
        }

        # File tree
        neo-tree-nvim
        # neo-tree dependencies
        nui-nvim
        # neo-tree optional dependencies
        nvim-web-devicons
        image-nvim

        # Other
        markdown-preview-nvim
      ] ++ vimPlugins;
    };
  }
