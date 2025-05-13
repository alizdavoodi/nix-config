self: super: {
  aider-chat = super.aider-chat-with-playwright.overridePythonAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "v0.83.1";
      hash = "sha256-2OHPqsS1znl7G4Z8mu8oKHNPdDr4YmSfGzXLylTgooE=";
    };
  });
}
