return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  config = true,
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.keybinds"] = {},
      ["core.norg.completion"] = {
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
      ["core.norg.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/projects/notes",
            todos = "~/projects/todos",
          },
        },
      },
    },
  },
  dependencies = { { "nvim-lua/plenary.nvim" } },
}
