{ unstable-aider, pkgs, system, inputs, unstable, ... }:

{
  imports = [
    ./cli
    #./nvim
    ./nvim/lazyvim # { _module.args.neovim9 = neovim9; }
    ./alacritty
    ./kitty
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
    # Development Tools and Languages
    cargo
    nodejs
    devbox
    nil
    nodePackages.prettier
    unstable-aider
    (python3.withPackages (ps:
      with ps; [
        boto3
        colorama
        cryptography
        jinja2
        libtmux
        packaging
        pyjwt
        pyyaml
      ]))
    sumneko-lua-language-server
    terraform-ls
    yarn
    podman

    # Version Control and Git Tools
    delta
    gh

    # Cloud and Infrastructure
    aiac
    ansible
    ansible-lint
    unstable.awscli2
    docker-compose
    kubectl
    kubectx
    kubernetes-helm
    terraform
    tflint

    # File and System Utilities
    comma
    du-dust
    extract_url
    fd
    lftp
    rclone
    ripgrep
    unzip
    uv
    xdg-utils
    yazi

    # Text Processing and Formatting
    jq
    nixfmt
    nodePackages.prettier
    ruff

    # Network Tools
    dogdns
    htop
    lynx
    mtr
    postgresql
    sshuttle
    wget
    wireguard-tools

    # Security Tools
    age
    libfido2
    sops
    yubikey-manager
    yubikey-personalization

    # Terminal and Shell Enhancements
    inputs.aichat.packages.${system}.default
    krew
    powerline-fonts
    unstable.claude-code
    (nerdfonts.override {
      fonts = [ "Meslo" "Iosevka" "JetBrainsMono" "VictorMono" ];
    })

    # Multimedia Tools
    sox
    yt-dlp

    # Utilities and Other Tools
    just
  ];

}
