{ pkgs, ... }:
{
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableLightTheme = false;
    fuzzySearchFactor = 1;
    keyScheme = "vim";

  };
  home.sessionVariables = {
    MCFLY_RESULTS_SORT = "LAST_RUN";
  };
}
