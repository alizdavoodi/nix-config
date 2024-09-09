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

  nil = inputs.nil.packages.${system}.default;
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

  xdg.enable = true;

  home.packages = with pkgs; [
    ascii-image-converter
    du-dust
    yubikey-personalization
    yubikey-manager
    awscli2
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
    yarn
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
    postgresql
    gh
    rclone
    ansible
    jq
    powerline-fonts
    wireguard-tools
    kubectx
    kubernetes-helm
    ansible-lint
    tflint
    libfido2
    terraform-ls
    sumneko-lua-language-server
    nodePackages.prettier
    (python310.withPackages (ps:
      with ps; [
        libtmux
        packaging
        pyyaml
        colorama
        boto3
        jinja2
        cryptography
        pyjwt
      ]))
    (nerdfonts.override {
      fonts = [ "Meslo" "Iosevka" "JetBrainsMono" "VictorMono" ];
    })
  ];

}
