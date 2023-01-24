{ config, lib, pkgs, inputs, ... }: {

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

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile "${inputs.tmux-conf}/.tmux.conf";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.mkTmuxPlugin {
            name = "tmux-window-name";
            pluginName = "tmux-window-name";
            src = fetchFromGitHub {
              owner = "ofirgall";
              repo = "tmux-window-name";
              rev = "a10a0d7d9ff1eaafdfd8054a1af0b53b6016d75a";
              sha256 = "6Uunqizl4NY7YcS4ygJusRYysTrbXyKlSDsiryvBSFU=";
            };
          };
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.fzf-tmux-url;
      }
      {
        plugin = tmuxPlugins.tmux-fzf;
      }
      {
        plugin = tmuxPlugins.tmux-thumbs;
      }
    ];
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  home.file.".tmux.conf.local" = { source = ./.tmux.conf.local; };
}
