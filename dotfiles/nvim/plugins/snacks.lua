-- Skip auto-pairs in snacks buffers (pickers, inputs, terminals). auto-pairs
-- wraps the buffer's <CR> mapping on BufEnter by reading its rhs, and snacks
-- maps <CR> to a Lua callback, which has no rhs (E716: Key not present in
-- Dictionary: "rhs"). Marking the buffer as loaded makes auto-pairs skip it.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_*",
  callback = function(args)
    vim.b[args.buf].autopairs_loaded = 1
  end,
})

-- snacks.input and snacks.picker setup recommended by
-- https://github.com/nickjvandyke/opencode.nvim
require("snacks").setup({
  input = {
    enabled = true, -- Enhances Ask
  },
  picker = {
    enabled = true, -- Enhances Select
    win = {
      input = {
        keys = {
          ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
        },
      },
    },
    actions = {
      opencode_send = function(picker) ---@param picker snacks.Picker
        local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
          return item.file
            and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
            or item.text
        end, picker:selected({ fallback = true }))

        require("opencode").prompt(table.concat(items, ", ") .. " ")
      end,
    },
  },
})
