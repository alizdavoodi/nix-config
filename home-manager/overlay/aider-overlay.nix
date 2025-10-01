self: super: {
  aider-chat-with-playwright = super.aider-chat-with-playwright.overridePythonAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "v0.86.0";
      hash = "sha256-pqwsYObgio50rbuGGOmi7PlEMxdX75B1ONKs+VAJrd8=";
    };
  });
}
