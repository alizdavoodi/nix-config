vim.g.vim_tree_respect_buf_cwd = 1

require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    view = {
        number = true,
        relativenumber = true,
    },
    filters = {
        custom = { ".git" },
    },
    update_focused_file = {
        enable = true,
       -- update_cwd = true,
    },
})

vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>')

local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
    return require 'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
    bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
    bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
    bufferline_api.set_offset(0)
end)
