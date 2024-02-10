return {
  "robitx/gp.nvim",
  config = function()
    require("gp").setup()

    -- or setup with your own config (see Install > Configuration in Readme)
    -- require("gp").setup(config)
  end,
}
