
local opts = { noremap = true, silent = true }
-- Move to previous/next
vim.api.nvim_set_keymap('n', '<c-h>', '<Cmd>BufferPrevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<c-l>', '<Cmd>BufferNext<CR>', opts)
-- Close buffer
vim.api.nvim_set_keymap('n', '<c-c>', '<Cmd>BufferClose<CR>', opts)

-- Magic buffer-picking mode
vim.api.nvim_set_keymap('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
