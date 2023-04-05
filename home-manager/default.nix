{  config, pkgs, system, inputs, ... }:

let
   kubectlPkgs = import (builtins.fetchGit {
       name = "kubectl-1-22";
       url = "https://github.com/NixOS/nixpkgs/";
       ref = "refs/heads/nixpkgs-unstable";
       rev = "6d02a514db95d3179f001a5a204595f17b89cb32";
     }) {
      inherit system;
     };
   kubectl122 = kubectlPkgs.kubectl;
in
{
  imports = [
    ./cli
    #./nvim
    ./nvim/lazyvim
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

  home.packages = with pkgs; [
    nixFlakes
    ascii-image-converter
    du-dust
    cargo
    comma
    unzip
    terraform
    urlview
    nodejs
    dogdns
    ripgrep
    kubectl122
    neovim
    openjdk
    go
    fd
    mtr
    xdg-utils
    pinentry
    nil
    awscli2
    lftp
    delta
    ansible
    jq
    powerline-fonts
    nerdfonts
    cascadia-code
    kubectx
    kubernetes-helm
    ansible-lint
    tflint
    terraform-ls
    sumneko-lua-language-server
    nodePackages.prettier
    nodePackages.web-ext
    python3Packages.libtmux
    python3Packages.packaging
  ];


  #oh-my-zsh customs theme
  # home.file.".oh-my-zsh/custom/themes/dracula.zsh-theme".source = builtins.fetchGit { 
  #   url = "https://github.com/dracula/zsh.git";
  #   ref = "refs/tags/v1.2.5";
  #   shallow = true;
  #   rev = "1f53554b2a2e3b7d3f0039e095ea84c05c08f064";
  # } + "/dracula.zsh-theme";

  #oh-my-zsh customs plugins
  # home.file.".oh-my-zsh/custom/plugins/zsh-kubectl-prompt".source =  builtins.fetchGit { 
  #   url = "https://github.com/superbrothers/zsh-kubectl-prompt.git"; 
  #   ref = "refs/heads/master";
  #   rev = "eb31775d6196d008ba2a34e5d99fb981b5b3092d";
  # };

  
}
