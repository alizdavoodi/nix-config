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
  
  # TODO: use upstream neovim when it fixes the build
  # Just remove this and use neovim-unwrapped
  neovim9Pkgs = import (builtins.fetchGit {
      name = "neovim-0.9";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/master";
      rev = "8eb9ed0cd532e776c7cba121c1f900b75980391f";
      }) {
          inherit system;
        
      };

  neovim9 = neovim9Pkgs.neovim-unwrapped;
in
{
  imports = [
    ./cli
    #./nvim
    ./nvim/lazyvim { _module.args.neovim9 = neovim9; }
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
    kubectl125
    openjdk
    go
    fd
    mtr
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
