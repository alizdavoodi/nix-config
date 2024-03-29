return {
  "nvim-neorg/neorg",
  config = true,
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.keybinds"] = {},
      ["core.summary"] = {},
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.presenter"] = {
        config = {
          zen_mode = "zen-mode",
          slide_count = {
            enable = true,
            position = "top",
            count_format = "[%d/%d]",
          },
        },
      },
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/projects/notes",
            todos = "~/projects/todos",
          },
        },
      },
    },
  },
  dependencies = {
    { "nvim-lua/plenary.nvim" },

    "vhyrro/luarocks.nvim",
    priority = 1000, -- We'd like this plugin to load first out of the rest
    config = true, -- This automatically runs `require("luarocks-nvim").setup()`
  },
}
