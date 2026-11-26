require('diffview').setup({
  -- Show lines removed on the old side in red instead of Neovim's default
  -- DiffAdd green, and changed text in red/green per side
  enhanced_diff_hl = true,
})

-- Review all changes against the index/HEAD (file panel: - stages/unstages a
-- file, X discards it); press again to close
vim.keymap.set('n', '<leader>gd', function()
  if require('diffview.lib').get_current_view() then
    vim.cmd('DiffviewClose')
  else
    vim.cmd('DiffviewOpen')
  end
end, { desc = 'Toggle diffview' })

vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'History of current file' }) -- % limits history to the current file
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>', { desc = 'History of repo' }) -- no argument means whole repo
