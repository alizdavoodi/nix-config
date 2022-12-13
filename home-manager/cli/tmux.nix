{ config, lib, pkgs, inputs, ... }: {
  #home.file.".tmux.conf" = { source = "${inputs.tmux-conf}/.tmux.conf"; };

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
