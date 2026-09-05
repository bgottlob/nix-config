-- Colorscheme
vim.cmd("colorscheme solarized")
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none", bg = "none" })

-- Turn on line numbers
vim.opt.number = true

-- Set column for 80 character limit per line
vim.opt.colorcolumn = "81"

-- Turn off mouse interactions
vim.opt.mouse = ""

-- Set up vim-slime for use within tmux
vim.g.slime_target = "tmux"
