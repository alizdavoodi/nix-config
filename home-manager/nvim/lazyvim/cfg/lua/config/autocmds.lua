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

-- Disable autoformat for go files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Run gofmt + goimport on save
local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
  group = format_sync_grp,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(current_buf, "filetype", "terraform")
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  callback = function()
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 80
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    local o = vim.o
    local fn = vim.fn
    if not o.binary and o.filetype ~= "diff" then
      local current_view = fn.winsaveview()
      vim.cmd([[keeppatterns %s/\s\+$//e]])
      fn.winrestview(current_view)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "/home/alizdavoodi/.local/share/nvim/gp/*",
  callback = function()
    -- Disable diagnostics for the current buffer
    vim.diagnostic.disable(0)
  end,
})
