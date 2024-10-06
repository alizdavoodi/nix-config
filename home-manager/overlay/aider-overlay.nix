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
      rev = "main";
      hash = "sha256-5uf+bHvAYNBca8kCo1H5h0kW71P4o0UD2DBlYescCGA=";
    };

    # Explicitly set the 'name' attribute
    name = "${oldAttrs.pname}";

    # Append new dependencies to the existing list
    dependencies = oldAttrs.dependencies ++ (with python3.pkgs; [ pydub ]);
  });
}
