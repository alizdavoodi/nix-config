return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "lukas-reineke/cmp-rg",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "rg" } }))
    -- Disable preselect of auto-completion
    opts.preselect = cmp.PreselectMode.None
    opts.completion = {
      completeopt = "menu,menuone,noselect,noinsert",
    }

    opts.mapping = cmp.config.mapping.preset.insert({
      ["<CR>"] = cmp.config.disable,
    })

    opts.experimental = {
      ghost_text = false,
    }
  end,
}
