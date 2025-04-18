self: super: {
  aider-chat = super.aider-chat.overridePythonAttrs (oldAttrs: rec {
    # inherit python3;

    src = super.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "v0.81.0";
      hash = "sha256-xWOXsffLAVBZvJM8PuAJ12IrmNLfXuqHrbIMtPM1leE=";
    };

    name = "${oldAttrs.pname}";

    #   buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ super.playwright-driver ];
    #
    #   nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ])
    #     ++ [ super.makeWrapper ];
    #
    #   propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ])
    #     ++ (with python3.pkgs; [
    #       grep-ast
    #       tree-sitter
    #       tree-sitter-c-sharp
    #       tree-sitter-embedded-template
    #       tree-sitter-yaml
    #       tree-sitter-language-pack
    #       typing-inspection
    #     ]);
    #
    #   nativeCheckInputs = [ ];
    #
    #   dependencies = oldAttrs.dependencies ++ (with python3.pkgs; [
    #     pydub
    #     mixpanel
    #     monotonic
    #     posthog
    #     propcache
    #     greenlet
    #     socksio
    #     playwright
    #     grep-ast
    #     pyee
    #     pip
    #     typing-extensions
    #     watchfiles
    #     google-generativeai
    #   ]);
    #
    #   postFixup = (oldAttrs.postFixup or "") + ''
    #     wrapProgram $out/bin/aider \
    #       --set PLAYWRIGHT_BROWSERS_PATH ${super.playwright-driver.browsers}
    #   '';
    # });
  });
}

