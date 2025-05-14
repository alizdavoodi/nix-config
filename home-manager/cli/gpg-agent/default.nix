{
  pkgs,
  lib,
  unstable,
  ...
}:
{
  programs.gpg = {
    enable = true;
    package = unstable.gnupg;
    settings = {
      default-key = "A597A0150D11DC311D67FC75080FBD10AEE8F171";
      keyserver = "hkps://keys.openpgp.org";
      keyserver-options = "auto-key-retrieve";
    };
    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".gnupg/gpg-agent.conf".text = ''
      enable-ssh-support
      ttyname $GPG_TTY
      default-cache-ttl 60
      max-cache-ttl 120
      pinentry-program ${lib.getExe pkgs.pinentry_mac}
    '';
  };
}
