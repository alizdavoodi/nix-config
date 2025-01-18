-- return {
--   "saghen/blink.cmp",
--   opts = function(_, opts)
--     opts.sources.default = vim.tbl_extend("force", opts.sources.default, {
--       "ripgrep",
--     })
--     -- opts.sources.compat = { "rg", "look" }
--     vim.notify(vim.inspect(opts))
--   end,
-- }

return {
  "saghen/blink.cmp",
  dependencies = {
    "mikavilpas/blink-ripgrep.nvim",
    -- "octaltree/cmp-look",
    "saghen/blink.compat",
    "Kaiser-Yang/blink-cmp-dictionary",
  },
  opts = {
    keymap = { preset = "default" },
    sources = {
      default = { "ripgrep" },
      providers = {
        ripgrep = {
          name = "Ripgrep",
          module = "blink-ripgrep",
        },
        -- dictionary = {
        --   module = "blink-cmp-dictionary",
        --   name = "Dict",
        --   opts = {
        --     get_command = {
        --       "rg", -- make sure this command is available in your system
        --       "--color=never",
        --       "--no-line-number",
        --       "--no-messages",
        --       "--no-filename",
        --       "--ignore-case",
        --       "--",
        --       "${prefix}",
        --       vim.fn.expand("~/.config/nvim/en_dict.txt"),
        --     },
        --     documentation = {
        --       enable = false, -- enable documentation to show the definition of the word
        --     },
        --   },
        -- },
      },
    },
  },
}
