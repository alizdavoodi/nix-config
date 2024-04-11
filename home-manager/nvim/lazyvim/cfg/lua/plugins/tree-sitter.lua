return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          -- init_selection = "<c-space>",
          node_incremental = "v",
          node_decremental = "V",
          -- scope_incremental = "<c-s>",
        },
      },
      ensure_installed = {
        "bash",
        "vimdoc",
        "html",
        "c",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "go",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "terraform",
        "nix",
        "norg",
      },
    },
  },
}
