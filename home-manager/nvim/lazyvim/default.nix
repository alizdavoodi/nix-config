{ inputs, system, ... }:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${system}.default;
    vimAlias = true;
  };

  xdg.configFile.nvim = {
    source = ./cfg;
    recursive = true;
  };
}
