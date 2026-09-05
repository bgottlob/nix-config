require('nvim-treesitter').setup {}

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'csv',
    'elixir',
    'erlang',
    'heex',
    'javascript',
    'json',
    'just',
    'tex',
    'lua',
    'markdown',
    'nix',
    'r',
    'ruby',
    'rust',
    'terraform',
    'toml',
    'yaml',
  },
  callback = function()
    vim.treesitter.start()
  end,
})
