{  config, pkgs, ... }:
let
  font-name = "MesloLGM Nerd Font";
in {
  programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
        # Spread additional padding evenly around the terminal content.
          dynamic_padding =  true;
          option_as_alt = "OnlyLeft";
          # Startup Mode (changes require restart)
          startup_mode = "Fullscreen";
        };
        shell = {
           program = "${pkgs.zsh}/bin/zsh";
         };
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        font = {
          size = 15;
          normal = {
            family = "${font-name}";
            style = "Regular";
          };
          bold = {
            family = "${font-name}";
            style = "Bold";
          };
          italic = {
            family = "${font-name}";
            style = "Italic";
          };

          offset = {
            x =  0;
            y = 0;
          };

          glyph_offset = {
            x =  0;
            y = 0;
          };
        };
        # Colors (Dracula)
        # themes: https://github.com/eendroroy/alacritty-theme
        colors = {
          # Default colors
          primary = {
            background = "0x282a36";
            foreground = "0xf8f8f2";
          };
          # Normal colors
          normal = {
            black = "0x000000";
            red = "0xff5555";
            green = "0x50fa7b";
            yellow = "0xf1fa8c";
            blue = "0xbd93f9";
            magenta = "0xff79c6";
            cyan = "0x8be9fd";
            white = "0xbbbbbb";
          };
          # Bright colors
          bright = {
            black = "0x555555";
            red = "0xff5555";
            green = "0x50fa7b";
            yellow = "0xf1fa8c";
            blue = "0xcaa9fa";
            magenta = "0xff79c6";
            cyan = "0x8be9fd";
            white = "0xffffff";
          };
        };
      };
    };
}
