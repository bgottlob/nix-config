-- Diff highlights: solarized gives the diff groups foreground colors, which
-- replace syntax highlighting on diffed lines. Use background tints only so
-- syntax colors stay visible. Changed lines only highlight the changed text
-- within them (DiffText).
local function blend(fg, bg, alpha)
  local function channel(color, shift)
    return math.floor(color / 2 ^ shift) % 256
  end
  local result = 0
  for _, shift in ipairs({ 16, 8, 0 }) do
    local c = channel(fg, shift) * alpha + channel(bg, shift) * (1 - alpha)
    result = result + math.floor(c + 0.5) * 2 ^ shift
  end
  return result
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "solarized",
  callback = function()
    local base03 = 0x002b36 -- solarized background
    local green, yellow = 0x859900, 0xb58900
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = 0x142e27 })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = 0x322728 })
    vim.api.nvim_set_hl(0, "DiffChange", {})
    vim.api.nvim_set_hl(0, "DiffText", { bg = blend(yellow, base03, 0.35) })
    vim.api.nvim_set_hl(0, "DiffTextAdd", { bg = blend(green, base03, 0.25) })
  end,
})

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
