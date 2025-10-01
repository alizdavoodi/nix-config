return {
  "mason-org/mason.nvim",
  opts = {
    -- To resolve the NixOS issue, the process initially searches for the LSP server
    -- binary within the operating system. If it is not found, it then checks for
    -- a Mason-installed version of the binary.
    PATH = "append",
    ensure_installed = {
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
    },
  },
}
