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
      rev = "v0.64.0";
      hash = "sha256-/UUZ72YVr046CnnLLM9p0O/1dqXkfgRaUZF1LwjUH44=";
    };

    name = "${oldAttrs.pname}";

    dependencies = oldAttrs.dependencies
      ++ (with python3.pkgs; [ pydub mixpanel monotonic posthog propcache ]);

    disabledTests = oldAttrs.disabledTests ++ [ "test_pipe_editor" ];
  });
}