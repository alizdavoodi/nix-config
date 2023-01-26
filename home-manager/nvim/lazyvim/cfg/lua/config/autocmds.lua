-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.j2" },
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(current_buf, "filetype", "yaml")
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/ansible/*.yml", "*/ansible/*.yaml" },
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(current_buf, "filetype", "yaml.ansible")
  end,
})
