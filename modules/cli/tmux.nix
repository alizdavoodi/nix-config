{ config, lib, pkgs, inputs, ... }: {

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile "${inputs.tmux-conf}/.tmux.conf";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
    ];
  };

  home.file.".tmux.conf.local" = { source = ./.tmux.conf.local; };
}
