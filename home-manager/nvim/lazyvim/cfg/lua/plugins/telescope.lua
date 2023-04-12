return {
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   dependencies = {
  --     { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  --     { "someone-stole-my-name/yaml-companion.nvim" },
  --   },
  --   -- apply the config and additionally load fzf-native
  --   config = function(_, opts)
  --     local telescope = require("telescope")
  --     telescope.setup(opts)
  --     telescope.load_extension("fzf")
  --     telescope.load_extension("yaml_schema")
  --   end,
  -- },
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "someone-stole-my-name/yaml-companion.nvim",
        config = function()
          require("telescope").load_extension("yaml_schema")
        end,
      },
    },
    opts = {
      defaults = {
        path_display = { "smart" },
      },
      pickers = {
        find_files = {
          path_display = { "truncate" },
        },
      },
    },
  },
}
