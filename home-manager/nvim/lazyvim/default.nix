{  config, neovim9, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = neovim9;
  };

  xdg.configFile.nvim = {
    source = ./cfg;
    recursive = true;
  };
}
