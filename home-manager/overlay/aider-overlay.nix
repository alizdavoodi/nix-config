self: super: {
  aider-chat = super.aider-chat-with-playwright.overridePythonAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "v0.85.0";
      hash = "sha256-ZYjDRu4dAOkmz+fMOG8KU6y27RI/t3iEoTSUebundqo=";
    };
  });
}
