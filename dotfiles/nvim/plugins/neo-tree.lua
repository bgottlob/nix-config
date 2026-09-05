vim.keymap.set('n', '<leader>t', ':Neotree toggle<CR>', {})
vim.keymap.set('n', '<leader>T', function()
  require('neo-tree.sources.manager').refresh('filesystem')
end, {})
