-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--map("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Open fzf-lua" })
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })

-- Neogit
-- I'm using the function by LazyVim
vim.keymap.set("n", "<leader>gg", function()
  require("neogit").open()
end, { noremap = true, silent = true, desc = "Open Neogit" })

-- Telescope
vim.api.nvim_set_keymap("n", "<leader>fr", ":Telescope file_browser<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>bb", ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><space>", ":Telescope find_files<CR>", { noremap = true, silent = true })

-- center screen after jumping
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Harpoon
-- local harpoon = require("harpoon")
-- vim.keymap.set("n", "<leader>ha", function()
--   harpoon:list():add()
-- end)
--
-- vim.keymap.set("n", "<leader>hh", function()
--   harpoon.ui:toggle_quick_menu(harpoon:list())
-- end, { noremap = true, desc = "Toggle Harpoon Menu" })
--
-- vim.keymap.set("n", "<leader>1", function()
--   harpoon:list():select(1)
-- end)
-- vim.keymap.set("n", "<leader>2", function()
--   harpoon:list():select(2)
-- end)
-- vim.keymap.set("n", "<leader>3", function()
--   harpoon:list():select(3)
-- end)
-- vim.keymap.set("n", "<leader>4", function()
--   harpoon:list():select(4)
-- end)
--

-- recommended mappings smart-splits
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
-- swapping buffers between windows
vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

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
