return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- add tsx and treesitter and nix
        ensure_installed = {
          "tsx",
          "typescript",
          "nix",
          "terraform",
        },
      })
    end,
  },
}
