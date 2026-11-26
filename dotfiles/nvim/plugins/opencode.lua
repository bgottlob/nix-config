-- Recommended setup from https://github.com/nickjvandyke/opencode.nvim, using
-- its snacks.terminal integration for the OpenCode pane

-- --continue: prompts go to the most recently updated session, so open that
-- one instead of a blank session
-- --auto (toggled with <leader>oA): auto-approve permissions that aren't
-- explicitly denied, like Claude Code's auto mode
local opencode_auto = false
local function opencode_cmd()
  return 'opencode --continue' .. (opencode_auto and ' --auto' or '')
end
---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  win = {
    position = 'right',
    enter = false,
    wo = {
      -- snacks draws windows with NormalFloat, which solarized gives a lighter
      -- background; use Normal so the pane matches the rest of Neovim
      winhighlight = 'Normal:Normal,NormalNC:Normal',
    },
    -- snacks makes side splits fixed-width (after applying wo, so it can't be
    -- overridden there), which makes <C-w>= skip the pane. Also update the
    -- stored options, since snacks reapplies them later (e.g. on update).
    on_win = function(win)
      win.opts.wo.winfixwidth = false
      vim.wo[win.win].winfixwidth = false
    end,
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function()
      require('snacks.terminal').open(opencode_cmd(), snacks_terminal_opts)
    end,
  },
}

-- Toggle the OpenCode pane. Normal mode only: a <leader> mapping in terminal
-- mode would add input delay when typing in OpenCode.
vim.keymap.set('n', '<leader>ot', function()
  require('snacks.terminal').toggle(opencode_cmd(), snacks_terminal_opts)
end, { desc = 'Toggle OpenCode' })

-- Toggle auto-approve by restarting the pane's TUI with or without --auto on
-- the same session. OpenCode has no mid-session toggle.
vim.keymap.set('n', '<leader>oA', function()
  local term = require('snacks.terminal').get(opencode_cmd(), { create = false })
  -- Only reopen the pane if it was showing; a hidden pane stays hidden and is
  -- recreated with the new mode next time it's shown
  local was_open = term ~= nil and term:win_valid()
  if term then
    local buf = term.buf
    if buf and vim.api.nvim_buf_is_valid(buf) then
      -- Skip snacks' "Terminal exited with code -1" error for this intended stop
      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = 'TermClose', buffer = buf })) do
        vim.api.nvim_del_autocmd(autocmd.id)
      end
    end
    term:close()
    -- Make sure the old TUI process is gone
    if buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  opencode_auto = not opencode_auto
  if was_open then
    require('snacks.terminal').open(opencode_cmd(), snacks_terminal_opts)
  end
  vim.notify('OpenCode auto-approve ' .. (opencode_auto and 'on' or 'off'))
end, { desc = 'Toggle OpenCode auto-approve' })

-- Show the pane when OpenCode starts executing. Unlike the README, also create
-- it if needed: when the service is already running, the plugin never calls
-- server.start, so a new Neovim would otherwise have no pane.
vim.api.nvim_create_autocmd('User', {
  pattern = { 'OpencodeEvent:session.execution.started' },
  callback = function()
    local win = require('snacks.terminal').get(opencode_cmd(), snacks_terminal_opts)
    if win then
      win:show()
    end
  end,
})

-- Reload buffers after OpenCode edits files. The plugin reloads on
-- file.edited/filesystem.changed, but OpenCode v2.3.0 doesn't send either for
-- its own edits; it reports them as session.tool.success instead.
vim.api.nvim_create_autocmd('User', {
  pattern = { 'OpencodeEvent:session.tool.success' },
  callback = function()
    vim.schedule(function()
      vim.cmd('checktime')
    end)
  end,
  desc = 'Reload buffers edited by OpenCode',
})

-- Recommended/example keymaps, except Ask/Select use <leader>oa/<leader>os
-- instead of <C-a>/<C-x>, which vim-speeddating maps (and wins, since it loads
-- after this config)
vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end,                   { desc = "Ask OpenCode…" })
vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,                         { desc = "Select OpenCode…" })
vim.keymap.set({ "n", "x" }, "go",         function() return require("opencode").operator("@this") end,        { desc = "Send range to OpenCode", expr = true })
vim.keymap.set({ "n" },      "goo",        function() return require("opencode").operator("@this") .. "_" end, { desc = "Send line to OpenCode", expr = true })
