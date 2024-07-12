{ config, pkgs, ... }:
let font-name = "JetBrainsMono Nerd Font";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        # Spread additional padding evenly around the terminal content.
        dynamic_padding = true;
        option_as_alt = "Both";
        # Startup Mode (changes require restart)
        startup_mode = "Fullscreen";

        decorations = "None";
      };
      shell = { program = "${pkgs.zsh}/bin/zsh"; };
      scrolling = {
        history = 50000;
        multiplier = 3;
      };
      font = {
        size = 17;
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
          x = 0;
          y = 0;
        };

        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
      # Colors section of "Alacritty - TOML configuration file format"
      # https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.5.scd#colors
      colors = {
        primary = {
          foreground = "#e0def4";
          background = "#191724";
          dim_foreground = "#908caa";
          bright_foreground = "#e0def4";
        };

        cursor = {
          text = "#e0def4";
          cursor = "#524f67";
        };

        vi_mode_cursor = {
          text = "#e0def4";
          cursor = "#524f67";
        };

        search = {
          matches = {
            foreground = "#908caa";
            background = "#26233a";
          };
          focused_match = {
            foreground = "#191724";
            background = "#ebbcba";
          };
        };

        hints = {
          start = {
            foreground = "#908caa";
            background = "#1f1d2e";
          };
          end = {
            foreground = "#6e6a86";
            background = "#1f1d2e";
          };
        };

        line_indicator = {
          foreground = "None";
          background = "None";
        };

        footer_bar = {
          foreground = "#e0def4";
          background = "#1f1d2e";
        };

        selection = {
          text = "#e0def4";
          background = "#403d52";
        };

        normal = {
          black = "#26233a";
          red = "#eb6f92";
          green = "#31748f";
          yellow = "#f6c177";
          blue = "#9ccfd8";
          magenta = "#c4a7e7";
          cyan = "#ebbcba";
          white = "#e0def4";
        };

        bright = {
          black = "#6e6a86";
          red = "#eb6f92";
          green = "#31748f";
          yellow = "#f6c177";
          blue = "#9ccfd8";
          magenta = "#c4a7e7";
          cyan = "#ebbcba";
          white = "#e0def4";
        };

        dim = {
          black = "#6e6a86";
          red = "#eb6f92";
          green = "#31748f";
          yellow = "#f6c177";
          blue = "#9ccfd8";
          magenta = "#c4a7e7";
          cyan = "#ebbcba";
          white = "#e0def4";
        };
      };
    };
  };
}
