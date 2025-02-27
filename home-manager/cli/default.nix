{ config, lib, pkgs, inputs, ... }: {

  imports = [ ./chatgpt-cli ./starship ./terminal ./sops ./gpg-agent ];

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
      EDITOR = "nvim";
      ANTHROPIC_API_KEY =
        "$(cat ${config.sops.secrets.anthropic_api_key.path})";
      OPENAI_API_KEY = "$(cat ${config.sops.secrets.openai_api_key_work.path})";
      OPENROUTER_API_KEY =
        "$(cat ${config.sops.secrets.openrouter_api_key.path})";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "colorize" "colored-man-pages" "kubectl" ];
      theme = "";
      custom = "$HOME/.oh-my-zsh/custom";
    };

    shellAliases = {
      gramm = "aichat --model openai:o3-mini -r grammar-genie";
      gramm2 = "aichat --model openai:o3-mini -r crystal-clear";
    };

    initExtra = ''
      export AWS_PROFILE=InfraOps-sympower
      export KUBECONFIG=~/.kube/kubeconfig

      if type rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --hidden'
        export FZF_DEFAULT_OPTS='-m --height 50% --border'
      fi

      # zsh-vi-mode
      ZVM_LAZY_KEYBINDINGS=false
      ZVM_VI_ESCAPE_BINDKEY=jk

      # Fix the issue with the `clear` command not working properly in zsh
      # https://vrongmeal.com/blog/clear-screen-preserve-buffer
      my-clear() {
        for i in {3..$(tput lines)}
        do
          printf '\n'
        done
        zle clear-screen
      }
      zle -N my-clear
      bindkey '^L' my-clear

      # To launch gpg-agent for use by SSH, use the gpg-connect-agent /bye or gpgconf --launch gpg-agent commands.
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
      gpg-connect-agent updatestartuptty /bye > /dev/null

      #Jump world with alt + arrow
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word



      # This function, `ssh-ec2`, provides an interactive way to connect to AWS EC2 instances via SSH.
      # It retrieves a list of EC2 instances using the AWS CLI, formats the output, and presents it in a
      # fuzzy finder interface (fzf) for selection. The user can then choose an instance to connect to
      # based on its Instance ID, Name, Hostname, and State. The function handles errors in retrieving
      # instances and ensures only instances with hostnames are displayed. Upon selection, it connects
      # to the chosen instance using SSH with agent forwarding enabled.
      ssh-ec2() {
        # Retrieve and format EC2 instances with launch time
        local instances=$(aws ec2 describe-instances \
          --query 'Reservations[*].Instances[*].[
            InstanceId,
            Tags[?Key==`Name`].Value | [0],
            PublicDnsName || PrivateDnsName,
            State.Name,
            LaunchTime
          ]' \
          --output text 2>/dev/null | \
          awk -F'\t' 'BEGIN {OFS=" | "} {
            if ($3 != "") {
              $2 = ($2 == "") ? "unnamed" : $2;
              print $1, $2, $3, $4, $5
            }
          }')

        if [[ $? -ne 0 ]]; then
          echo "ERROR: Failed to retrieve EC2 instances. Check your AWS configuration."
          return 1
        fi

        if [[ -z "$instances" ]]; then
          echo "No EC2 instances found."
          return 0
        fi

        # Fuzzy-find with raw creation time in preview
        local selected=$(echo "$instances" | \
          fzf --height 40% --reverse \
              --header="Instance ID | Name | Hostname | State" \
              --preview "echo -e 'Instance ID: {1}\nName: {2}\nHostname: {3}\nState: {4}\nCreated: {5}'" \
              --preview-window=wrap:50% \
              --delimiter=" \| " --with-nth=1,2,3 \
              --bind 'change:first')

        if [[ -n "$selected" ]]; then
          local hostname=$(echo "$selected" | awk -F' \| ' '{print $3}')
          echo "Connecting to $hostname..."
          ssh -A "$hostname"
        fi
      }
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
        plugin = tmuxPlugins.mkTmuxPlugin {
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

  xdg.configFile.ghostty = {
    target = "ghostty/config";
    source = ./ghostty/config;
    # recursive = true;
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      repoPaths = { # configure where to locate repos when checking out PRs
        ":owner/:repo" =
          "~/projects/github.com/:owner/:repo"; # template if you always clone github repos in a consistent location
      };
      # keybindings = {
      #   prs = [{
      #     key = "c";
      #     command = ''
      #       tmux new-window -c {{.RepoPath}} '
      #         gh pr checkout {{.PrNumber}} &&
      #         nvim -c ":DiffviewOpen master...{{.HeadRefName}}"
      #       '
      #     '';
      #   }];
      # };
    };
  };

}
