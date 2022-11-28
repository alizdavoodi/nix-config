{ config, pkgs, ... }:
let
     kubectlPkgs = import (builtins.fetchGit {
         name = "kubectl-1-22";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixpkgs-unstable";
         rev = "6d02a514db95d3179f001a5a204595f17b89cb32";
       }) {};
     extraNodePackages = import ./node/default.nix {};
     kubectl122 = kubectlPkgs.kubectl;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "davoodi";
  home.homeDirectory = "/Users/davoodi";

  home.packages = with pkgs; [
    du-dust
    ripgrep
    kubectl122
    pinentry
    awscli2
    delta
    ansible
    tmux
    python
    fzf
    powerline-fonts
    ghq
    nerdfonts
    kubectx
    kubernetes-helm
    ansible-lint
    tflint
    terraform-ls
    sumneko-lua-language-server
    nodePackages.yaml-language-server
    nodePackages.prettier
    
    extraNodePackages."@ansible/ansible-language-server"
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  
  #oh-my-zsh customs theme
  home.file.".oh-my-zsh/custom/themes/dracula.zsh-theme".source = builtins.fetchGit { 
    url = "https://github.com/dracula/zsh.git";
  } + "/dracula.zsh-theme";

  #oh-my-zsh customs plugins
  home.file.".oh-my-zsh/custom/plugins/zsh-kubectl-prompt".source =  builtins.fetchGit { url = "https://github.com/superbrothers/zsh-kubectl-prompt.git"; };

  
  programs.broot.enable = true;
  programs.bat = {
    enable = true;
    config = {
      theme = "GitHub";
      italic-text = "always";
    };
  };

  programs.neovim = {
   enable = true;
   vimAlias = true;

   plugins = with pkgs.vimPlugins; [
     vim-nix
     vim-helm
     nvim-cmp
     cmp-nvim-lsp
     cmp-rg
     nvim-lspconfig
     luasnip
     vim-lua
     cmp-path
     cmp-buffer
     fidget-nvim
     vim-sleuth
     ansible-vim
     fzf-vim
     nvim-web-devicons
     plenary-nvim
     vim-fugitive
     vim-rhubarb
     gitsigns-nvim
     neoformat
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
     telescope-project-nvim
     telescope-fzf-native-nvim
     barbar-nvim
     {
       plugin = nvim-tree-lua;
       type = "lua";
       config = ''
            require("nvim-tree").setup({
              disable_netrw = true,
              hijack_netrw = true,
              view = {
                number = true,
                relativenumber = true,
              },
              filters = {
                custom = { ".git" },
              },
            })

            
            vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>')
         '';
     }

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
    augroup nvim
    au!
    au VimEnter * doautoa Syntax,FileType
    augroup END
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

      -- Set highlight on search
      vim.o.hlsearch = false

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
      -- Gitsigns
      -- See `:help gitsigns.txt`
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
      
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
    :luafile ~/.config/nvim/lua/init.lua
   '';
 };

 xdg.configFile.nvim = {
  source = ./config;
  recursive = true;
 };

 programs.zsh = {
    enable = true;
    autocd = true;
    history = {
      ignoreSpace = true;
      size = 50000;
      save = 50000;
      expireDuplicatesFirst = true;
    };
    sessionVariables = {
      colorterm = "truecolor";
      term = "xterm-256color";
      editor = "vim";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "dirhistory" "colorize" "colored-man-pages" "fzf" "kubectl" "zsh-kubectl-prompt"];
      theme = "dracula";
      custom = "$HOME/.oh-my-zsh/custom";
    };
    
    initExtra = ''
      ## Kubectl prompt
      RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

      export AWS_PROFILE=companyinfo
      export KUBECONFIG=~/.kube/kubeconfig

      if type rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --hidden'
        export FZF_DEFAULT_OPTS='-m --height 50% --border'
      fi

      # yubikey gpg
      export GPG_TTY=$TTY
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent

    '' + builtins.readFile
      (builtins.fetchGit {
      url = "https://github.com/ahmetb/kubectl-aliases";
      ref = "master";
      } + "/.kubectl_aliases");
  };
}
