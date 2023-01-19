
local opts = { noremap = true, silent = true }
local remap = function (mode, key, rhs, opt)
    vim.api.nvim_set_keymap(mode, key, rhs, opt)
end

-- Move to previous/next
vim.api.nvim_set_keymap('n', '<c-h>', '<Cmd>BufferPrevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<c-l>', '<Cmd>BufferNext<CR>', opts)
-- Close buffer
vim.api.nvim_set_keymap('n', '<c-c>', '<Cmd>BufferClose<CR>', opts)

-- Magic buffer-picking mode
vim.api.nvim_set_keymap('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)

remap('n', "<c-<>", "<Cmd>BufferMovePrevious<CR>", opts)
remap('n', "<c->>", "<Cmd>BufferMoveNext<CR>", opts)

