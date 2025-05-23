{
  unstable-aider,
  pkgs,
  system,
  inputs,
  unstable,
  ...
}:

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
  };

  xdg.enable = true;

  home.packages = with pkgs; [
    # Development Tools and Languages
    cargo
    nodejs
    devbox
    nil
    nodePackages.prettier
    # unstable.aider-chat-with-playwright
    unstable-aider
    (python3.withPackages (
      ps: with ps; [
        boto3
        colorama
        cryptography
        jinja2
        libtmux
        packaging
        pyjwt
        pyyaml
      ]
    ))
    sumneko-lua-language-server
    terraform-ls
    yarn
    go

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
    # nixfmt
    nodePackages.prettier
    ruff
    nixd
    nixfmt-rfc-style

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
    unstable.libfido2
    unstable.sops
    unstable.yubikey-manager
    unstable.yubikey-personalization

    # Terminal and Shell Enhancements
    inputs.aichat.packages.${system}.default
    krew
    powerline-fonts
    unstable.claude-code
    nerd-fonts."meslo-lg"
    nerd-fonts.iosevka
    nerd-fonts."jetbrains-mono"
    nerd-fonts."victor-mono"

    # Multimedia Tools
    sox
    yt-dlp

    # Utilities and Other Tools
    just
  ];

}
