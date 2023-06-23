{  config, pkgs, system, inputs, ... }:

let
    kubectlPkgs = import (builtins.fetchGit {
        name = "kubectl-1-25"; 
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixpkgs-unstable";
        rev = "79b3d4bcae8c7007c9fd51c279a8a67acfa73a2a";
      }) { 
       inherit system;
      }; 
   /*Use default kubectl */
   kubectl125 = kubectlPkgs.kubectl;

in
{
  imports = [
    ./cli
    #./nvim
    ./nvim/lazyvim #{ _module.args.neovim9 = neovim9; }
    ./alacritty
    #./macfly
    ./starship
    ./git
    ./lazygit
  ];
  
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.broot.enable = true;
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      color = "always";
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  home.packages = with pkgs; [
    nixFlakes
    ascii-image-converter
    du-dust
    yt-dlp
    comma
    gnupg
    docker-compose
    unzip
    htop
    terraform
    urlview
    nodejs
    inputs.wait4x.packages.${system}.default
    dogdns
    ripgrep
    kubectl125
    openjdk
    go
    cargo
    fd
    mtr
    wget
    pinentry-curses
    xdg-utils
    pinentry
    nil
    sshuttle
    awscli2
    lftp
    delta
    ansible
    jq
    powerline-fonts
    kubectx
    kubernetes-helm
    ansible-lint
    tflint
    terraform-ls
    sumneko-lua-language-server
    nodePackages.prettier
    python3Packages.libtmux
    python3Packages.packaging
    (nerdfonts.override { fonts = [ "Meslo" "Iosevka" "JetBrainsMono"]; })
  ];

  
}
