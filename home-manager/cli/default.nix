{ config, lib, pkgs, inputs, ... }: {

  imports = [ ./chatgpt-cli ./starship ];

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
      # colorterm = "truecolor";
      # term = "xterm-256color";
      editor = "nvim";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "colorize" "colored-man-pages" "kubectl" ];
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
      # zsh-vi-mode
      ZVM_LAZY_KEYBINDINGS=false
      ZVM_VI_ESCAPE_BINDKEY=jk
      # enable flake
      export NIX_CONFIG="experimental-features = nix-command flakes"
    '' + builtins.readFile (builtins.fetchGit {
      url = "https://github.com/ahmetb/kubectl-aliases";
      rev = "b2ee5dbd3d03717a596d69ee3f6dc6de8b140128";
    } + "/.kubectl_aliases");
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile "${inputs.tmux-conf}/.tmux.conf";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      { plugin = tmuxPlugins.fzf-tmux-url; }
      { plugin = tmuxPlugins.tmux-fzf; }
      { plugin = tmuxPlugins.tmux-thumbs; }
      {
        plugin = tmuxPlugins.mkTmuxPlugin rec {
          pluginName = "tmux-session-wizard";
          version = "0.1.0";
          rtpFilePath = "session-wizard.tmux";

          src = fetchFromGitHub {
            owner = "27medkamal";
            repo = "tmux-session-wizard";
            rev = "96918e95b6fd2f73e29fb08bd6f371bec929df32";
            sha256 = "sha256-GJ9Jz4mpz8ov7kALEZdfxUZciERvuKYAG82LU8HQbUQ=";
          };
          meta = with lib; {
            description =
              "Creating a new session from a list of recently accessed directories";
            homepage = "https://github.com/27medkamal/tmux-session-wizard";
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
      }
    ];
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file."${config.xdg.configHome}/tmux/tsesh.sh".source =
    ./scripts/tsesh.sh;

  xdg.configFile.tmux = {
    target = "tmux/tmux.conf.local";
    source = ./.tmux.conf.local;
    recursive = true;
  };

}
