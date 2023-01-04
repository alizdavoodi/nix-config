{ pkgs, ...}:
{
  programs.neovim = {
   enable = true;
   vimAlias = true;

    plugins = with pkgs.vimPlugins; [
     nvim-ufo
     promise-async
     mason-nvim
     mason-lspconfig-nvim
     yaml-companion
     nerdcommenter
     vim-nix
     nvim-cmp
     cmp-nvim-lsp
     cmp-rg
     nvim-lspconfig
     luasnip
     vim-lua
     cmp-path
     indent-blankline-nvim
     sensible
     cmp-buffer
     fidget-nvim
     vim-sleuth
     #ansible-vim
     fzf-vim
     nvim-web-devicons
     plenary-nvim
     vim-fugitive
     vim-rhubarb
     gitsigns-nvim
     vim-gitgutter
     neoformat
     nvim-neoclip-lua
     #vim-surround
     (nvim-treesitter.withPlugins (plugins: with plugins; [
      tree-sitter-bash
      tree-sitter-c
      tree-sitter-css
      tree-sitter-dockerfile
      tree-sitter-elm
      tree-sitter-go
      tree-sitter-haskell
      tree-sitter-hcl
      tree-sitter-html
      tree-sitter-java
      tree-sitter-javascript
      tree-sitter-json
      tree-sitter-latex
      tree-sitter-lua
      tree-sitter-markdown
      tree-sitter-markdown-inline
      tree-sitter-nix
      tree-sitter-python
      tree-sitter-regex
      tree-sitter-ruby
      tree-sitter-rust
      tree-sitter-scss
      tree-sitter-sql
      tree-sitter-toml
      tree-sitter-tsx
      tree-sitter-typescript
      tree-sitter-yaml
    ]))
    telescope-nvim
    project-nvim
     telescope-fzf-native-nvim
     barbar-nvim
     vim-polyglot
     nvim-hlslens
    nvim-tree-lua

    vim-commentary 
     # UI #####
     gruvbox
     everforest 
     vim-airline
     vim-airline-themes
   ];

   extraConfig = ''    
    set encoding=utf-8
    set fileencoding=utf-8
    set termencoding=utf-8
    " Copy yank to system clipboard
    set clipboard=unnamedplus

    " Whitespace handling {{{
    set nowrap
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set expandtab
    set list listchars=tab:»·,trail:·
    " }}}
    " NeoVim-specific {{{
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1

    " Neovim takes a different approach to initializing the GUI. As It seems some
    " Syntax and FileType autocmds don't get run all for the first file specified
    " on the command line.  hack sidesteps that and makes sure we get a chance to
    " get started. See https://github.com/neovim/neovim/issues/2953
    " augroup nvim
    " au!
    " au VimEnter * doautoa Syntax,FileType
    " augroup END

    au BufRead,BufNewFile *.j2 set filetype=yaml
    au BufRead,BufNewFile */ansible/*.yml,*/ansible/*.yaml set filetype=yaml.ansible

    " }}}
    " Syntax Highlighting {{{
    if $TERM_BG == "light"
      set background=light
    else
      set background=dark
    endif
    colorscheme everforest
    " Set contrast.
    " This configuration option should be placed before `colorscheme everforest`.
    " Available values: 'hard', 'medium'(default), 'soft'
    let g:everforest_background = 'soft'

    " load the plugin and indent settings for the detected filetype
    filetype plugin indent on
    " }}}

    " LightLine {{{
    let g:airline_theme='everforest'
    let g:airline_powerline_fonts = 1
    " }}}

    lua << EOF
      -- [[ Setting options ]]
      -- See `:help vim.o`

      -- Make line numbers default
      vim.wo.number = true

      -- Enable mouse mode
      vim.o.mouse = 'a'

      -- Enable break indent
      vim.o.breakindent = true

      -- Save undo history
      vim.o.undofile = true

      -- Case insensitive searching UNLESS /C or capital in search
      vim.o.ignorecase = true
      vim.o.smartcase = true

      -- Decrease update time
      vim.o.updatetime = 250
      vim.wo.signcolumn = 'yes'

      -- [[ Basic Keymaps ]]
      -- Set <space> as the leader key
      -- See `:help mapleader`
      --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
      -- Set completeopt to have a better completion experience
      vim.o.completeopt = 'menuone,noselect'
      vim.opt.termguicolors = true

      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help indent_blankline.txt`
      require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
      require('telescope-config')
      -- Turn on status information
      require('fidget').setup()
      
      -- nvim-cmp setup
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'rg' },
        },
      }

    EOF
    luafile ${builtins.toString ./init_lua.lua}
   '';
   };
    xdg.configFile = {
      "nvim/lua" = {
        source = ./lua;
        recursive = true;
    };
    "nvim/init_lua.lua".source = ./init_lua.lua;
  };
}
