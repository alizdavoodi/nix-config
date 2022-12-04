{
inputs = {
   #Neovim Fold
      nvim-ufo = {
        url = "github:kevinhwang91/nvim-ufo";
        flake = false;
      };

      promise-async = {
        url = "github:kevinhwang91/promise-async";
        flake = false;
      };
      
      # LSP server installation
      mason-nvim = {
        url = "github:williamboman/mason.nvim";
        flake = false;
      };
      mason-lspconfig-nvim = {
        url = "github:williamboman/mason-lspconfig.nvim";
        flake = false;
      };
      yaml-companion = {
        url = "github:someone-stole-my-name/yaml-companion.nvim";
        flake = false;
      };
  };
  outputs = inputs:
    let
      missingVimPluginsInNixpkgs = pkgs: {
        nvim-ufo = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "nvim-ufo";
          src = inputs.nvim-ufo;
        };
        promise-async = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "promise-async";
          src = inputs.promise-async;
        };
        mason-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "mason-nvim";
          src = inputs.mason-nvim;
        };
        mason-lspconfig-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "mason-lspconfig-nvim";
          src = inputs.mason-lspconfig-nvim;
        };
        yaml-companion = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "yaml-companion";
          src = inputs.yaml-companion;
        };
      };
    in
    {
      overlay = _final: prev: {
        vimPlugins = prev.vimPlugins // (missingVimPluginsInNixpkgs prev.pkgs);
      };
    };
}
