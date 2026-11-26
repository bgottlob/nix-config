-- Setup from https://github.com/windwp/nvim-autopairs
require('nvim-autopairs').setup({
  -- Use treesitter to avoid adding pairs where they don't belong (e.g. strings)
  check_ts = true,
})

-- Insert `(` after confirming a function or method in nvim-cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
