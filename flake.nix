{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";

    hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";

    vim-plugins = {
      url = "path:./home-manager/nvim/plugins";
    };

    tmux-conf = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };

    # Delta is a syntax-highlighting pager for git, diff, and grep output.
    # NOTE: Include just for "themes.gitconfig" file 
    delta = { 
      url = "github:dandavison/delta";
      flake = false; 
    };

    neovim-nightly = {
      url = "github:neovim/neovim?dir=contrib";
    };

  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
  let
    inherit (self) outputs;
    home-common = { lib, ...}:
    {

      programs.home-manager.enable = true;
      home.stateVersion = "22.05";

      nixpkgs.overlays = [
        inputs.vim-plugins.overlay
        inputs.neovim-nightly.overlay
        ];

      imports = [
        ./home-manager
      ];

    };

    work-macbook = {
      home.username = "davoodi";
      home.homeDirectory = "/Users/davoodi"; 
    };
    home-pc = {
      home.username = "alizdavoodi";
      home.homeDirectory = "/home/alizdavoodi";
    };
  in
  {
    nixosConfigurations = {
      "alizdavoodi@nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        #nix.settings.experimental-features = [ "nix-command" "flakes" ];
        # > Our main nixos configuration file <
        modules = [ ./nixos/configuration.nix ];
      };
    };

    homeConfigurations = {
      "alizdavoodi@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs; system="x86_64-linux";};
        # > Our main home-manager configuration file <
        modules = [
          home-common
          home-pc
        ];
      };

      "davoodi@MC220424" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs; system="aarch64-darwin"; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [
          home-common
          work-macbook
        ];
      };
    };
  };
}
