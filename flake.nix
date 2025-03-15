{
  description = "Your new nix config";
  nixConfig = {
    substituters = [ "https://cache.nixos.org" "https://devenv.cachix.org" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    extra-experimental-features = [ "nix-command" "flakes" ];
  };
  inputs = {
    # Nixpkgs
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
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
      url =
        "git+ssh://git@github.com/alizdavoodi/secrets.git?ref=main&shallow=1";
      flake = false;
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # nil = {
    #   url = "github:oxalica/nil";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Add the aichat flake
    aichat.url = "path:./flakes/aichat";
    aichat.inputs.nixpkgs.follows = "nixpkgs";
    aichat.inputs.flake-utils.follows = "flake-utils";

    # neovim-nightly = {
    # url = "github:neovim/neovim?dir=contrib";
    # inputs.nixpkgs.follows = "nixpkgs";
    # inputs.flake-utils.follows = "flake-utils";
    # };

    #alacritty = {
    #  url = "path:./home-manager/alacritty/alacritty-nightly";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    let
      inherit (self) outputs;

      home-common = { lib, system, pkgs, ... }: {

        nixpkgs = { config = { allowUnfree = true; }; };
        programs.home-manager.enable = true;
        home.stateVersion = "22.05";

        nixpkgs.overlays =
          [ (import ./home-manager/overlay/aider-overlay.nix) ];
        imports = [ ./home-manager ];

      };

      work-macbook = { pkgs, ... }: {
        home.username = "alirezadavoodi";
        home.homeDirectory = "/Users/alirezadavoodi";

        home.packages = with pkgs; [ fuse macfuse-stubs openssh docker ];
      };

      home-server = { pkgs, system, ... }: {
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
        ];
      };

    in {
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
        "alizdavoodi@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
            system = "x86_64-linux";
            unstable = import inputs.nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          # > Our main home-manager configuration file <
          modules = [ home-common home-server ];
        };

        "alizdavoodi@work" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
            system = "aarch64-darwin";
          }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [ home-common work-macbook ];
        };
      };
    };
}
