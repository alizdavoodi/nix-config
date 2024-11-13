self: super:
let
  # Override python3
  python3 = super.python311.override {
    packageOverrides = self_: super_: {
      tree-sitter = super_.tree-sitter_0_21;
    };
  };
in {
  aider-chat = super.aider-chat.overridePythonAttrs (oldAttrs: rec {
    # version = "0.59.1.dev";
    inherit python3;

    src = super.fetchFromGitHub {
      owner = "paul-gauthier";
      repo = "aider";
      rev = "v0.62.1";
      hash = "sha256-Lwsxh0QSHOEoo4hrP0WsxIeuKFpm7b7u/mbcVQrRmdM=";
    };

    # Explicitly set the 'name' attribute
    name = "${oldAttrs.pname}";

    # Append new dependencies to the existing list
    dependencies = oldAttrs.dependencies
      ++ (with python3.pkgs; [ pydub mixpanel monotonic posthog propcache ]);
  });
}
