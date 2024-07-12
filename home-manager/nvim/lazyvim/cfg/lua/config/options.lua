-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"

vim.o.colorcolumn = "120"
vim.o.conceallevel = 2

vim.o.background = "dark"
-- Using lsp_lines instead of lsp_diagnostics
vim.diagnostic.config({
  virtual_text = false,
})

-- copilot assume mapped
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_filetypes = {
--   yaml = true,
-- }
