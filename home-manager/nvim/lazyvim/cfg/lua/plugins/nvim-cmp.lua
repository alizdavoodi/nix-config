return {
  "hrsh7th/nvim-cmp",
  dependencies = { "lukas-reineke/cmp-rg" },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "rg" } }))
  end,
}
