{ inputs, config, ... }:
let secretpath = builtins.toString inputs.secrets;
in {

  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = "${secretpath}/secrets.yaml";
    validateSopsFiles = false;

    gnupg.home = "${config.home.homeDirectory}/.gnupg";
    # age = {
    #   # automatically import host SSH keys as age keys
    #   # sshKeyPaths = [""]
    #   # keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    #   generateKey = true;
    # };

    secrets = {
      anthropic_api_key = { };
      openai_api_key_work = { };
      openrouter_api_key = { };
      gemini_api_key = { };
    };
  };
}
