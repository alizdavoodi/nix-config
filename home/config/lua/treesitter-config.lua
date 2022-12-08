-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`

require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  -- ensure_installed = { 'go', 'lua', 'yaml' }
  withAllGrammars = { enable = true },
  highlight = {
    enable = true,
    disable = { "yaml" },
    additional_vim_regex_highlighting = false,
  },
  --  indent = { enable = false },
}
