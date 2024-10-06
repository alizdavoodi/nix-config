{ config, pkgs, ... }:

let font-name = "JetBrainsMono Nerd Font";
in {
  programs.kitty = {
    enable = true;
    font = {
      name = font-name;
      size = 13;
    };
    themeFile = "rose-pine";
    shellIntegration = { enableZshIntegration = true; };
    scrollback_lines = 10000;
    extraConfig = ''
      modify_font cell_width 80%
      modify_font cell_height -2px
      modify_font baseline 3
    '';

  };
}
