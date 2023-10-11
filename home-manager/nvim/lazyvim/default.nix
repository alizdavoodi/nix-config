{ config, ... }:

{
   programs.neovim = {
     enable = true;
     vimAlias = true;
   };
  
   xdg.configFile.nvim = {
     source = ./cfg;
     recursive = true;
   };
}
