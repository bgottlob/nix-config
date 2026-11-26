-- Keymaps based on the gitsigns.nvim README. Hunk actions live under
-- <leader>h; the README's <leader>t* toggles are moved under <leader>h too
-- since <leader>t toggles neo-tree.
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation: next/previous hunk, or the native diff motion in diff mode
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, { desc = 'Next hunk' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, { desc = 'Previous hunk' })

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage/unstage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Stage/unstage selected lines' })

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Reset selected lines' })

    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end, { desc = 'Blame line' })
    map('n', '<leader>hB', gitsigns.toggle_current_line_blame, { desc = 'Toggle current line blame' })

    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end, { desc = 'Diff against last commit' })

    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { desc = 'Quickfix: all hunks in repo' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = 'Quickfix: hunks in buffer' })

    -- Text object: ih selects the hunk under the cursor (e.g. vih, dih)
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select hunk' })
  end,
})
