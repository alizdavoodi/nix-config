self: super:
let
  python3 = super.python312.override {
    packageOverrides = self_: super_: {
      tree-sitter = super_.tree-sitter_0_21;
      # Override the default grep-ast package
      # FIXME: remove all the refrences to grep-ast when the new version is merged to unstable
      grep-ast = self_.buildPythonPackage rec {
        pname = "grep-ast";
        version = "0.6.1";
        pyproject = true;

        src = self_.fetchPypi {
          inherit version;
          pname = "grep_ast";
          hash = "sha256-uQRYCpkUl6/UE1xRohfQAbJwhjI7x1KWc6HdQAPuJNA=";
        };

        nativeBuildInputs = [ self_.setuptools ];

        propagatedBuildInputs = [ self_.pathspec self_.tree-sitter-languages ];

        nativeCheckInputs = [ self_.pytestCheckHook ];

        pythonImportsCheck = [ "grep_ast" ];

        meta = with super.lib; {
          homepage = "https://github.com/paul-gauthier/grep-ast";
          description = "Python implementation of the ast-grep tool";
          license = licenses.asl20;
        };
      };
    };
  };
in {
  aider-chat = super.aider-chat.overridePythonAttrs (oldAttrs: rec {
    inherit python3;

    src = super.fetchFromGitHub {
      owner = "paul-gauthier";
      repo = "aider";
      rev = "v0.75.1";
      hash = "sha256-TQDYrkSW58E1/lIBuJsgpXst8OAbaTyNX1SM8mdFgzU=";
    };

    name = "${oldAttrs.pname}";

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ super.playwright-driver ];

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ])
      ++ [ super.makeWrapper ];

    propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ])
      ++ (with python3.pkgs; [ grep-ast ]);

    dependencies =
      builtins.filter (dep: dep.pname or "" != "grep-ast") oldAttrs.dependencies
      ++ (with python3.pkgs; [
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
      ]);

    postFixup = (oldAttrs.postFixup or "") + ''
      wrapProgram $out/bin/aider \
        --set PLAYWRIGHT_BROWSERS_PATH ${super.playwright-driver.browsers}
    '';

    # disabledTests = oldAttrs.disabledTests ++ [
    #   "test_pipe_editor"
    #   "test_pytest_env_vars"
    #   "test_simple_send_non_retryable_error"
    # ];
  });
}
