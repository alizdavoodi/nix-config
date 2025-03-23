# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  trezor-rules = pkgs.writeTextFile {
    name = "51-trezor.rules";
    text = ''
      # Trezor: The Original Hardware Wallet
      # https://trezor.io/
      #
      # Put this file into /etc/udev/rules.d
      #
      # If you are creating a distribution package,
      # put this into /usr/lib/udev/rules.d or /lib/udev/rules.d
      # depending on your distribution

      # Trezor
              SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
              KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

      # Trezor v2
              SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c0", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
              SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
              KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

      # Rules for Oryx web flashing and live training
              KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
              KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
        # Rule for all ZSA keyboards
              SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"

      # Wally Flashing rules for the Moonlander and Planck EZ
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"

    '';
    destination = "/etc/udev/rules.d/51-trezor.rules";
  };
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     pcsclite = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pcsclite;
  # pcscliteWithPolkit =
  #   inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pcscliteWithPolkit;
  #   })
  # ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    trusted-users = [ "root" "alizdavoodi" ];
    substituters = [
      "https://cache.nixos.org"
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.udev.packages = [ trezor-rules pkgs.yubikey-personalization ];
  # Enable OpenGL
  hardware.graphics.enable = true;

  # hardware.nvidia.prime = {
  #   offload = {
  #     enable = true;
  #     enableOffloadCmd = true;
  #   };
  #   #   intelBusId = "PCI:0:2:0";
  #   nvidiaBusId = "pci@0000:26:00.0";
  # };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    nvidiaPersistenced = true;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alizdavoodi = {
    isNormalUser = true;
    description = "alizdavoodi";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      docker
      obsidian
      #Python nvim
      ruff-lsp
      yarn
      ruff
      gcc
      gnumake
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # PC/SC smartcard daemon
  services.pcscd = { enable = true; };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cmake
    cargo
    hplip
    google-chrome
    telegram-desktop
    xclip
    pkg-config
    openssl
    wireguard-tools
    openboard
    trezor-suite
    # (python3.withPackages (ps: with ps; [ libtmux packaging ]))
  ];

  fonts.packages = with pkgs;
    [
      (nerdfonts.override {
        fonts =
          [ "CascadiaCode" "Meslo" "JetBrainsMono" "Iosevka" "VictorMono" ];
      })
    ];
  # for the next version
  # fonts.packages = with pkgs; [
  #   nerd-fonts.meslo-lg
  #   nerd-fonts.jetbrains-mono
  #   nerd-fonts.iosevka
  #   nerd-fonts.victor-mono
  # ];
  environment.variables = { OPENSSL_DEV = pkgs.openssl.dev; };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.ollama.enable = true;
  services.ollama.acceleration = "cuda";
  services.ollama.host = "0.0.0.0";
  # services.open-webui = {
  #   enable = true;
  #   environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
  # };
  services.openvpn.servers = {
    officeVPN = {
      config = "config /home/alizdavoodi/Downloads/alireza.davoodi.ovpn";
      updateResolvConf = true;
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 52415 ];
  # networking.firewall.allowedUDPPorts = [ 52415 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Open ports in the firewall.
  # networking.firewall.extracommands = ''
  #   iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 52415 -j nixos-fw-accept
  #   iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 52415 -j nixos-fw-accept
  # '';
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
