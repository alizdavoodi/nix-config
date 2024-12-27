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
  },
  opts = {
    keymap = { preset = "default" },
    sources = {
      default = { "ripgrep" },
      -- compat = { "look" },
      providers = {
        ripgrep = {
          name = "Ripgrep",
          module = "blink-ripgrep",
        },
      },
    },
  },
}
