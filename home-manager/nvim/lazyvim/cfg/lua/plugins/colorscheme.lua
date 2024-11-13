return {
  -- add gruvbox
  { "projekt0n/github-nvim-theme" },
  { "rebelot/kanagawa.nvim" },
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })
    end,
  },
  { "diegoulloao/neofusion.nvim", priority = 1000, config = true },
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  {
    "sainnhe/gruvbox-material",
    -- config = function()
    --   require("gruvbox").setup({
    --     transparent_mode = true,
    --   })
    -- end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        transparent = true,
      })
    end,
  },
  {
    "rose-pine/neovim",
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
    end,
  },
  { "miikanissi/modus-themes.nvim", priority = 1000 },
  {
    "tjdevries/colorbuddy.nvim",
  },
  { "EdenEast/nightfox.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      no_italic = true,
      term_colors = true,
      transparent_background = false,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
    },
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
