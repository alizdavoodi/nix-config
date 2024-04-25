{ config, pkgs, system, inputs, ... }:

let
  # kubectlPkgs = import (builtins.fetchGit {
  #   name = "kubectl-1-27";
  #   url = "https://github.com/NixOS/nixpkgs/";
  #   ref = "refs/heads/nixpkgs-unstable";
  #   rev = "976fa3369d722e76f37c77493d99829540d43845";
  # }) { inherit system; };
  # # Use default kubectl
  # kubectl127 = kubectlPkgs.kubectl;

in {
  imports = [
    ./cli
    #./nvim
    ./nvim/lazyvim # { _module.args.neovim9 = neovim9; }
    ./alacritty
    #./macfly
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
    krew
    sox
    sshuttle
    gnupg
    docker-compose
    unzip
    htop
    terraform
    extract_url
    nodejs
    dogdns
    ripgrep
    rclone
    gcc
    nixfmt
    openjdk
    go
    cargo
    fd
    fzf
    mtr
    wget
    aiac
    xdg-utils
    sops
    age
    nil
    sshuttle
    yazi
    # awscli2
    lftp
    delta
    gnumake
    rclone
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
    (nerdfonts.override {
      fonts = [ "Meslo" "Iosevka" "JetBrainsMono" "VictorMono" ];
    })
  ];

}
