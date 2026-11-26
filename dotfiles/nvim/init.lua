-- Colorscheme
vim.cmd("colorscheme solarized")
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none", bg = "none" })

-- Turn on line numbers
vim.opt.number = true

-- Set column for 80 character limit per line
vim.opt.colorcolumn = "81"

-- Turn off mouse interactions
vim.opt.mouse = ""

-- Reload buffers when files are changed on disk
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})

-- Set up vim-slime for use within tmux
vim.g.slime_target = "tmux"
