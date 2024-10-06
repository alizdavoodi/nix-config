{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      family = "monospace";
      size = 12;
    };
    # Add additional configuration options here
  };
}
