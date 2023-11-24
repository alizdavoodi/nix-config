# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Run cron
  systemd.timers."get-most-treaided" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "hello-world.service";
    };
  };

  systemd.services."hello-world" = {
    script = ''
      set -eu
      ${pkgs.coreutils}/bin/echo "Hello World"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
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

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = false;
    openFirewall = true;
  };
  # settings from avahi-daemon.nix where mdns is replaced with mdns4
  system.nssModules =
    pkgs.lib.optional (!config.services.avahi.nssmdns) pkgs.nssmdns;
  system.nssDatabases.hosts = with pkgs.lib;
    optionals (!config.services.avahi.nssmdns) (mkMerge [
      (mkBefore [ "mdns4_minimal [NOTFOUND=return]" ]) # before resolve
      (mkAfter [ "mdns4" ]) # after dns
    ]);

  # Enable sound with pipewire.
  sound.enable = true;
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
    packages = with pkgs;
      [
        firefox
        #  thunderbird
      ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
  # hardware.keyboard.zsa.enable = true;

  fonts.fonts = with pkgs;
    [
      (nerdfonts.override {
        fonts =
          [ "CascadiaCode" "Meslo" "JetBrainsMono" "Iosevka" "VictorMono" ];
      })
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    cmake
    cargo
    home-manager
    hplip
    google-chrome
    pkgconfig
    openssl
    wireguard-tools
    trezor-suite
    (python3.withPackages (ps: with ps; [ libtmux packaging ]))
  ];

  environment.variables = rec { OPENSSL_DEV = pkgs.openssl.dev; };

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
  services.udev.packages = [ trezor-rules ];
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    ports = [ 4042 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 6789 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 6789 -j nixos-fw-accept
    iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 8096 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 8096 -j nixos-fw-accept
    iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 8989 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 8989 -j nixos-fw-accept
    iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 7878 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 7878 -j nixos-fw-accept
    iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 5055 -j nixos-fw-accept
  '';
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
