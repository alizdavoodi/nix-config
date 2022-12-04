{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = github:numtide/flake-utils;
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";

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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      darwin = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      nvimCustomPlugins = {
        nvim-ufo = darwin.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-ufo";
          version = "main";
          src = inputs.nvim-ufo;
        };
        promise-async = darwin.vimUtils.buildVimPluginFrom2Nix {
          pname = "promise-async";
          version = "main";
          src = inputs.promise-async;
        };
        mason-nvim = darwin.vimUtils.buildVimPluginFrom2Nix {
          pname = "mason-nvim";
          version = "main";
          src = inputs.mason-nvim;
        };
        mason-lspconfig-nvim = darwin.vimUtils.buildVimPluginFrom2Nix {
          pname = "mason-lspconfig-nvim";
          version = "main";
          src = inputs.mason-lspconfig-nvim;
        };
        yaml-companion = darwin.vimUtils.buildVimPluginFrom2Nix {
          pname = "yaml-companion";
          version = "main";
          src = inputs.yaml-companion;
        };
      };

      nixosConfigurations = {
        "alizdavoodi@nixos" = nixpkgs.legacyPackages.aarch64-darwin.lib.nixosSystem {
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          # > Our main nixos configuration file <
          modules = [ ./nixos/configuration.nix ];
        };
      };

      homeConfigurations = {
        "alizdavoodi@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit (inputs.self) nvimCustomPlugins;  }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [ ./home/home.nix ];
        };

        "davoodi@MC220424" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit outputs; inherit (inputs.self) nvimCustomPlugins; }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [ ./home/davoodi/default.nix ];
        };
      };
    };
}
