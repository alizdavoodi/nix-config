{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";

    comma.url = "github:nix-community/comma";
    vim-plugins = {
      url = "path:./modules";
    };

    tmux-conf = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
  let
    inherit (self) outputs;
    home-common = { lib, ...}:
    {
      nixpkgs.overlays = [
          inputs.vim-plugins.overlay
      ];
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
        extraSpecialArgs = { inherit inputs outputs; };
        # > Our main home-manager configuration file <
        modules = [ ./home/davoodi/default.nix
            home-common
        ];
      };

      "davoodi@MC220424" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs; system="aarch64-darwin"; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./profiles/home-manager/davoodi/default.nix
          home-common
        ];
      };
    };
  };
}
