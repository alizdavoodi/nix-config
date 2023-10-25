-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--map("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Open fzf-lua" })
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })

-- local wk = require("which-key")
-- local chatgpt = require("chatgpt")
-- wk.register({
--   ["<leader>dl"] = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Show cursor diagnostics with Lspsaga" },
-- })
-- vim.keymap.set("i", "<C-g>", function()
--   return vim.fn["codeium#Accept"]()
-- end, { expr = true })
-- vim.keymap.set("i", "<c-;>", function()
--   return vim.fn["codeium#CycleCompletions"](1)
-- end, { expr = true })
-- vim.keymap.set("i", "<c-,>", function()
--   return vim.fn["codeium#CycleCompletions"](-1)
-- end, { expr = true })
-- vim.keymap.set("i", "<c-x>", function()
--   return vim.fn["codeium#Clear"]()
-- end, { expr = true })

--map copilot#Accept to <C-g>
-- vim.api.nvim_set_keymap("!", "<C-g>", 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true })
--
