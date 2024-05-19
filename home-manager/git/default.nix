{ inputs, lib, config, pkgs, ... }:

{
  home.packages = with pkgs; [ ghq ];

  programs.git = {
    enable = true;
    userName = "Alireza Davoodi";
    userEmail = "alizdavoodi@gmail.com";
    signing = {
      signByDefault = true;
      key = "0x7CC14AB284E9B569";
    };
    delta = {
      enable = true;
      options = {
        features = "decorations calochortus-lyallii";
        syntax-theme = "Dracula";
        line-numbers = true;
        navigate = true;
        side-by-side = true;
      };
    };
    ignores = [
      ".idea" # Jetbrains
    ];
    extraConfig = {
      format.signoff = true;
      diff.colorMoved = "default";
      ghq = {
        vcs = "git";
        root = "~/projects";
      };
      merge.conflictstyle = "diff3";
      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
        blame = "delta";
      };
      url = {
        "git@gitlab.ci.fdmg.org:".insteadOf = "https://gitlab.ci.fdmg.org/";
      };
    };
    includes = [
      { path = "${inputs.delta}/themes.gitconfig"; }
      {
        condition = "gitdir:~/projects";
        contents = {
          user = {
            name = "Alireza Davoodi";
            email = "alireza.davoodi@sympower.net";
            signingKey = "0x7CC14AB284E9B569";
          };
        };
      }
    ];
  };
}
