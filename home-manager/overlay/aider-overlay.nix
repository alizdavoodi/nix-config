self: super:
let
  python3 = super.python311.override {
    packageOverrides = self_: super_: {
      tree-sitter = super_.tree-sitter_0_21;
    };
  };
in {
  aider-chat = super.aider-chat.overridePythonAttrs (oldAttrs: rec {
    inherit python3;

    src = super.fetchFromGitHub {
      owner = "paul-gauthier";
      repo = "aider";
      rev = "v0.73.0";
      hash = "sha256-wcrwm4mn4D6pYgoCa5iKcKmt4QmhOXOfObUl7Gevukg=";
    };

    name = "${oldAttrs.pname}";

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ super.playwright-driver ];

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ])
      ++ [ super.makeWrapper ];

    dependencies = oldAttrs.dependencies ++ (with python3.pkgs; [
      pydub
      mixpanel
      monotonic
      posthog
      propcache
      greenlet
      playwright
      pyee
      pip
      typing-extensions
      watchfiles
    ]);

    postFixup = (oldAttrs.postFixup or "") + ''
      wrapProgram $out/bin/aider \
        --set PLAYWRIGHT_BROWSERS_PATH ${super.playwright-driver.browsers}
    '';

    disabledTests = oldAttrs.disabledTests ++ [
      "test_pipe_editor"
      "test_pytest_env_vars"
      "test_simple_send_non_retryable_error"
    ];
  });
}
