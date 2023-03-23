{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    #lazy git nix module settings
    settings = {
      git = {
        paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          };
      };
    };
  
  };
}
