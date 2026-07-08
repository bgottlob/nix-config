vim.g.rustaceanvim = function()
  return {
    server = {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      default_settings = {
        ['rust-analyzer'] = {
          checkOnSave = false,
        },
      },
    },
  }
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.rs",
  callback = function()
    vim.cmd("RustLsp flyCheck run")
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.rs",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local file = vim.fn.expand("%:p")
    local cursor = vim.api.nvim_win_get_cursor(0)
    local pre = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    vim.fn.jobstart({ "cargo", "fmt", "--", file }, {
      on_exit = function(_, code)
        if code == 0 then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("silent! edit")
                local post = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                if not vim.deep_equal(pre, post) then
                  pcall(vim.api.nvim_win_set_cursor, 0, cursor)
                  vim.cmd("normal! zz")
                end
              end)
            end
          end)
        end
      end
    })
  end,
})
