self: super:
let
  python3 = super.python312.override {
    packageOverrides = self_: super_: {
      tree-sitter = super_.tree-sitter_0_21;

      # Create dummy packages for the missing tree-sitter language modules
      tree-sitter-c-sharp = self_.buildPythonPackage {
        pname = "tree-sitter-c-sharp";
        version = "0.20.0";
        format = "setuptools";

        src = super.pkgs.writeTextDir "setup.py" ''
          from setuptools import setup
          setup(
              name="tree-sitter-c-sharp",
              version="0.20.0",
              description="C# grammar for tree-sitter",
              packages=[],
          )
        '';

        propagatedBuildInputs = [ self_.tree-sitter ];
        meta.description = "C# grammar for tree-sitter";
      };

      tree-sitter-embedded-template = self_.buildPythonPackage {
        pname = "tree-sitter-embedded-template";
        version = "0.20.0";
        format = "setuptools";

        src = super.pkgs.writeTextDir "setup.py" ''
          from setuptools import setup
          setup(
              name="tree-sitter-embedded-template",
              version="0.20.0",
              description="Embedded template grammar for tree-sitter",
              packages=[],
          )
        '';

        propagatedBuildInputs = [ self_.tree-sitter ];
        meta.description = "Embedded template grammar for tree-sitter";
      };

      tree-sitter-yaml = self_.buildPythonPackage {
        pname = "tree-sitter-yaml";
        version = "0.20.0";
        format = "setuptools";

        src = super.pkgs.writeTextDir "setup.py" ''
          from setuptools import setup
          setup(
              name="tree-sitter-yaml",
              version="0.20.0",
              description="YAML grammar for tree-sitter",
              packages=[],
          )
        '';

        propagatedBuildInputs = [ self_.tree-sitter ];
        meta.description = "YAML grammar for tree-sitter";
      };

      tree-sitter-language-pack = self_.buildPythonPackage {
        pname = "tree-sitter-language-pack";
        version = "0.20.0";
        format = "setuptools";

        src = super.pkgs.writeTextDir "setup.py" ''
          from setuptools import setup
          setup(
              name="tree-sitter-language-pack",
              version="0.20.0",
              description="Language pack for tree-sitter",
              packages=[],
          )
        '';

        propagatedBuildInputs = [
          self_.tree-sitter
          self_.tree-sitter-c-sharp
          self_.tree-sitter-embedded-template
          self_.tree-sitter-yaml
        ];
        meta.description = "Language pack for tree-sitter";
      };

      # Add typing-inspection package from PyPI wheel
      typing-inspection = self_.buildPythonPackage {
        pname = "typing-inspection";
        version = "0.4.0";
        format = "wheel";

        src = super.fetchurl {
          url =
            "https://files.pythonhosted.org/packages/py3/t/typing_inspection/typing_inspection-0.4.0-py3-none-any.whl";
          sha256 =
            "50e72559fcd2a6367a19f7a7e610e6afcb9fac940c650290eed893d61386832f";
        };

        propagatedBuildInputs = with self_; [
          mypy-extensions
          typing-extensions
        ];

        pythonImportsCheck = [ "typing_inspection" ];

        meta = {
          description = "Runtime typing introspection tools";
          homepage = "https://github.com/pydantic/typing-inspection";
          license = super.lib.licenses.mit;
        };
      };
    };
  };
in {
  aider-chat = super.aider-chat.overridePythonAttrs (oldAttrs: rec {
    inherit python3;

    src = super.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "v0.80.1";
      hash = "sha256-THJW3ZORXaRTeYE6Gmtu7Efi7F0VvU2wT7d/hQjhMzU=";
    };

    name = "${oldAttrs.pname}";

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ super.playwright-driver ];

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ])
      ++ [ super.makeWrapper ];

    propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ])
      ++ (with python3.pkgs; [
        grep-ast
        tree-sitter
        tree-sitter-c-sharp
        tree-sitter-embedded-template
        tree-sitter-yaml
        tree-sitter-language-pack
        typing-inspection
      ]);

    nativeCheckInputs = [ ];

    dependencies = oldAttrs.dependencies ++ (with python3.pkgs; [
      pydub
      mixpanel
      monotonic
      posthog
      propcache
      greenlet
      socksio
      playwright
      grep-ast
      pyee
      pip
      typing-extensions
      watchfiles
      google-generativeai
    ]);

    postFixup = (oldAttrs.postFixup or "") + ''
      wrapProgram $out/bin/aider \
        --set PLAYWRIGHT_BROWSERS_PATH ${super.playwright-driver.browsers}
    '';
  });
}

