return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "lukas-reineke/cmp-rg",
    "octaltree/cmp-look",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      { name = "rg" },
      {
        name = "look",
        keyword_length = 2,
        option = {
          convert_case = true,
          loud = true,
        },
      },
    }))
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

    -- Setup up vim-dadbod
    cmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })
  end,
}
