{ config, pkgs, ... }:

let
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

  toLuaStr = str: str;
  toLuaFile = file: builtins.readFile file;
in
  {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      initLua = toLuaFile ../../dotfiles/nvim/init.lua;

      withPython3 = false;
      withRuby = false;

      extraPackages = with pkgs; [
        # Rust
        cargo
        clippy
        graphviz
        rust-analyzer
        rustc

        # Elixir
        beamPackages.elixir
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
            p.just
            p.latex
            p.lua
            p.markdown
            p.nix
            p.r
            p.ruby
            p.rust
            p.terraform
            p.toml
            p.yaml
          ]));
          type = "lua";
          config = toLuaFile ../../dotfiles/nvim/plugins/treesitter.lua;
        }

        # LSP, snippet, and autocompletion plugins
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = (
            (toLuaFile ../../dotfiles/nvim/plugins/lspconfig.lua) + (
              toLuaStr ''
              vim.lsp.config('elixirls', {
                cmd = { "${pkgs.elixir-ls}/bin/elixir-ls" };
              })
              vim.lsp.enable('elixirls')

              -- Format Elixir/Heex buffers with mix format (via elixir-ls) on save
              vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                  local bufnr = args.buf
                  if vim.bo[bufnr].filetype ~= 'elixir' and vim.bo[bufnr].filetype ~= 'heex' then
                    return
                  end

                  local client = vim.lsp.get_client_by_id(args.data.client_id)
                  if not client or not client:supports_method('textDocument/formatting') then
                    return
                  end

                  vim.api.nvim_create_autocmd('BufWritePre', {
                    buffer = bufnr,
                    callback = function()
                      vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
                    end,
                  })
                end,
              })
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
          type = "lua";
          config = toLuaFile ../../dotfiles/nvim/plugins/telescope.lua;
        }

        # File tree
        {
          plugin = neo-tree-nvim;
          type = "lua";
          config = toLuaFile ../../dotfiles/nvim/plugins/neo-tree.lua;
        }
        # neo-tree dependencies
        nui-nvim
        # neo-tree optional dependencies
        nvim-web-devicons
        image-nvim

        # Other
        markdown-preview-nvim

        # Rust
        {
          plugin = rustaceanvim;
          type = "lua";
          config = toLuaFile ../../dotfiles/nvim/plugins/rustaceanvim.lua;
        }
      ] ++ vimPlugins;
    };
  }
