{ inputs, system, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    # package = inputs.neovim-nightly.packages.${system}.default;
  };

  xdg.configFile.nvim = {
    source = ./cfg;
    recursive = true;
  };
}
