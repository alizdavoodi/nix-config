{
  description = "Your new nix config";
  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    # home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";

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

    secrets = {
      url = "git+ssh://git@github.com/alizdavoodi/secrets.git?ref=main&shallow=1";
      flake = false;
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # nil = {
    #   url = "github:oxalica/nil";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Add the aichat flake
    aichat = {
      url = "path:./flakes/aichat";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    #alacritty = {
    #  url = "path:./home-manager/alacritty/alacritty-nightly";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs =
    {
      self,
      nixpkgs,
      unstable,
      home-manager,
      flake-utils,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Function to create the unstable-aider package using system
      mkUnstableAider =
        system:
        (import unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ (import ./home-manager/overlay/aider-overlay.nix) ];
        }).aider-chat-with-playwright;

      home-common =
        {
          lib,
          system,
          pkgs,
          ...
        }:
        {

          nixpkgs = {
            config = {
              allowUnfree = true;
            };
          };
          programs.home-manager.enable = true;
          home.stateVersion = "22.05";

          imports = [ ./home-manager ];

        };

      work-macbook =
        { pkgs, unstable, ... }:
        {
          home.username = "alirezadavoodi";
          home.homeDirectory = "/Users/alirezadavoodi";

          home.packages = with pkgs; [
            fuse
            macfuse-stubs
            unstable.openssh
            docker
          ];
        };

      home-server =
        {
          pkgs,
          system,
          unstable,
          ...
        }:
        {
          home.username = "alizdavoodi";
          home.homeDirectory = "/home/alizdavoodi";

          # packages specific for my home server
          home.packages = with pkgs; [
            gcc-arm-embedded
            wally-cli
            kubo
            qmk
            gtk3
            marksman
            stylua
            libusb1
            webkitgtk
            unstable.ghostty
          ];
        };

    in
    {
      nixosConfigurations = {
        "alizdavoodi@nixos" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          # nix.settings.experimental-features = [ "nix-command" "flakes" ];
          # > Our main nixos configuration file <
          modules = [ ./nixos/configuration.nix ];
        };

        "alizdavoodi-pc@nixos" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          # nix.settings.experimental-features = [ "nix-command" "flakes" ];
          modules = [ ./nixos/pc-alizdavoodi/configuration.nix ];
        };
      };

      homeConfigurations = {
        "alizdavoodi@nixos" =
          let
            system = flake-utils.lib.system.x86_64-linux;
            unstablePkgs = import unstable {
              inherit system;
              config.allowUnfree = true;
            };
          in
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = {
              inherit inputs outputs system;
              unstable = unstablePkgs;
              unstable-aider = mkUnstableAider system;
            };
            # > Our main home-manager configuration file <
            modules = [
              home-common
              home-server
            ];
          };

        "alizdavoodi@work" =
          let
            system = flake-utils.lib.system.aarch64-darwin;
            unstablePkgs = import unstable {
              inherit system;
              config.allowUnfree = true;
            };
          in
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = {
              inherit inputs outputs system;
              unstable-aider = mkUnstableAider system;
              unstable = unstablePkgs;
            }; # Pass flake inputs to our config
            # > Our main home-manager configuration file <
            modules = [
              home-common
              work-macbook
            ];
          };
      };
    };
}
