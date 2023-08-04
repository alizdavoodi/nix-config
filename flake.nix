{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";

    # Home manager
    #home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.url = "github:nix-community/home-manager";
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

    # neovim-nightly = {
    # url = "github:neovim/neovim?dir=contrib";
    # inputs.nixpkgs.follows = "nixpkgs";
    # inputs.flake-utils.follows = "flake-utils";
    # };

    #alacritty = {
    #  url = "path:./home-manager/alacritty/alacritty-nightly";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    wait4x = {
      url = "github:atkrad/wait4x";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    let
      inherit (self) outputs;
      home-common = { lib, system, ... }: {

        programs.home-manager.enable = true;
        home.stateVersion = "22.05";

        #nixpkgs.overlays = [
        #  inputs.alacritty.overlay.${system}
        #  ];

        imports = [ ./home-manager ];

    };

    work-macbook = {
      home.username = "davoodi";
      home.homeDirectory = "/Users/davoodi"; 
    };
    home-server = { pkgs, ...}:
    {
      home.username = "alizdavoodi";
      home.homeDirectory = "/home/alizdavoodi";

      # packages specific for my home server
      home.packages = with pkgs; [
        gcc-arm-embedded
        wally-cli
        qmk
        gtk3
        libusb1
        webkitgtk
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
        extraSpecialArgs = { inherit inputs outputs; system="x86_64-linux";};
        # > Our main home-manager configuration file <
        modules = [
          home-common
          home-server
        ];
      };
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
}
