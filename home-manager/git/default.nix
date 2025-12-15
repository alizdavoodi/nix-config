{ inputs, lib, config, pkgs, ... }:

{
  home.packages = with pkgs; [ ghq ];

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "0x7CC14AB284E9B569";
    };
    ignores = [
      ".idea" # Jetbrains
    ];
    settings = {
      user = {
        name = "Alireza Davoodi";
        email = "alizdavoodi@gmail.com";
      };
      format.signoff = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "main";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain"; # Changed from "default"
        mnemonicPrefix = true;
        renames = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      core.excludesfile = "~/.gitignore";
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "decorations calochortus-lyallii";
      syntax-theme = "Dracula";
      line-numbers = true;
      navigate = true;
      side-by-side = true;
    };
  };
}
