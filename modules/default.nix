{  config, pkgs, system, ... }:

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
  

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
      # Spread additional padding evenly around the terminal content.
        dynamic_padding =  true;

        # Startup Mode (changes require restart)
        startup_mode = "Fullscreen";
      };
      # shell = {
      #   program = "/Users/davoodi/.nix-profile/bin/zsh";
      #   args = [
      #     "l"
      #     "c"
      #     "tmux attach -t sessionname || tmux new -s sessionname"
      #   ];
      # };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        size = 15;
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "Menlo";
          style = "Italic";
        };

        offset = {
          x =  0;
          y = 0;
        };

        glyph_offset = {
          x =  0;
          y = 0;
        };
      };
      # Colors (Dracula)
      # themes: https://github.com/eendroroy/alacritty-theme
      colors = {
        # Default colors
        primary = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        # Normal colors
        normal = {
          black = "0x000000";
          red = "0xff5555";
          green = "0x50fa7b";
          yellow = "0xf1fa8c";
          blue = "0xbd93f9";
          magenta = "0xff79c6";
          cyan = "0x8be9fd";
          white = "0xbbbbbb";
        };
        # Bright colors
        bright = {
          black = "0x555555";
          red = "0xff5555";
          green = "0x50fa7b";
          yellow = "0xf1fa8c";
          blue = "0xcaa9fa";
          magenta = "0xff79c6";
          cyan = "0x8be9fd";
          white = "0xffffff";
        };
      };
    };
  };

  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableLightTheme = false;
    fuzzySearchFactor = 3;
    keyScheme = "vim";
  };

  # Starship Prompt
  programs.starship = {
    enable = true;
    settings = {
      kubernetes = {
        format = "on [⛵$context \($namespace\)](dimmed green)";
        disabled = false;
        context_aliases = {
          ".*eks:(?P<var_region>[\\\\w-]+).*:cluster/(?P<var_cluster>[\\\\w-]+)" = "$var_region:$var_cluster";
        };
      };
      aws = {
        disabled = true;
      };
    };
  };
  # Nicely reload system units when changing configs
  #systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    nixFlakes
    du-dust
    comma
    nodejs
    dogdns
    ripgrep
    kubectl122
    xdg-utils
    pinentry
    nil
    awscli2
    delta
    ansible
    tmux
    python
    jq
    fzf
    powerline-fonts
    ghq
    nerdfonts
    kubectx
    kubernetes-helm
    ansible-lint
    tflint
    terraform-ls
    sumneko-lua-language-server
    nodePackages.yaml-language-server
    nodePackages.prettier

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

  
  programs.broot.enable = true;
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      color = "always";
    };
  };


 programs.zsh = {
    enable = true;
    autocd = true;
    history = {
      ignoreSpace = true;
      size = 50000;
      save = 50000;
      expireDuplicatesFirst = true;
    };
    sessionVariables = {
      colorterm = "truecolor";
      term = "xterm-256color";
      editor = "vim";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "dirhistory" "colorize" "colored-man-pages" "kubectl"];
      theme = "";
      custom = "$HOME/.oh-my-zsh/custom";
    };
    
    initExtra = ''
      export AWS_PROFILE=companyinfo
      export KUBECONFIG=~/.kube/kubeconfig

      if type rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --hidden'
        export FZF_DEFAULT_OPTS='-m --height 50% --border'
      fi

      # yubikey gpg
      export GPG_TTY=$TTY
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
      
      # enable flake
      export NIX_CONFIG="experimental-features = nix-command flakes"
    '' + builtins.readFile
      (builtins.fetchGit {
      url = "https://github.com/ahmetb/kubectl-aliases";
      rev = "b2ee5dbd3d03717a596d69ee3f6dc6de8b140128"; 
      } + "/.kubectl_aliases");
  };
}
