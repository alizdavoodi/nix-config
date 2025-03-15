{ config, pkgs, ... }:

let font-name = "JetBrains Mono";
in {
  programs.kitty = {
    enable = true;
    font = {
      name = font-name;
      size = 18.0;
    };
    themeFile = "rose-pine";
    shellIntegration = { enableZshIntegration = true; };
    settings = {
      scrollback_lines = 50000;
      # background = "#000000";
      shell =
        "zsh --login -c 'if command -v tmux >/dev/null 2>&1; then tmux attach || tmux; else zsh; fi'";
      hide_window_decorations = "no";
      enable_audio_bell = "no";
    };
    extraConfig = ''
      # Kitty's font was more spaced compared to alacritty's, tried font variations
      # but it didn't change, so I went with this, it works fine
      # modify_font cell_width 95%

      # I was going crazy
      # after a kitty update, font height seemed smaller, this fixed it
      # modify_font cell_height 5px

      text_composition_strategy legacy
    '';

  };
}
