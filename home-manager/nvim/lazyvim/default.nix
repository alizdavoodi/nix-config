{  config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = pkgs.neovim;

  };

  xdg.configFile.nvim = {
    source = ./cfg;
    recursive = true;
  };
}
