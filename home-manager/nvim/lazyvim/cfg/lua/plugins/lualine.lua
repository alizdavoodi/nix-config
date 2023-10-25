local Util = require("lazyvim.util")

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- To show reletive path and overwrite lazyvim pretty_path function
    opts.sections.lualine_c[4] = { "filename", path = 1 }
  end,
}
