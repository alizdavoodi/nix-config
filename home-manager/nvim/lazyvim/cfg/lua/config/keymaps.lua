-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--map("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Open fzf-lua" })
vim.api.nvim_set_keymap("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })

local wk = require("which-key")
local chatgpt = require("chatgpt")
wk.register({
  p = {
    name = "ChatGPT",
    e = {
      function()
        chatgpt.edit_with_instructions()
      end,
      "Edit with instructions",
    },
  },
}, {
  prefix = "<leader>",
  mode = "v",
})

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
