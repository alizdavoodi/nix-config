{ ... }: {
  # Starship Prompt
  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[λ](green)";
        error_symbol = "[λ](red)";
      };
      kubernetes = {
        format = "on [⛵$context ($namespace)](dimmed green)";
        disabled = false;
        contexts = [{
          context_pattern =
            ".*eks:(?P<var_region>[\\w-]+).*:cluster/(?P<var_cluster>[\\w-]+)";
          context_alias = "$var_region:$var_cluster";
        }];
      };
      aws = { disabled = true; };
    };
  };
}
