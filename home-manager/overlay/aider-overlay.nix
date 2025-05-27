self: super: {
  aider-chat = super.aider-chat-with-playwright.overridePythonAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "v0.83.2";
      hash = "sha256-fVysmaB2jGS2XJlxyFIdJmQShzxz2q4TQf8zNuCT2GE=";
    };
  });
}
