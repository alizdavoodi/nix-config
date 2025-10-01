return {
  "Bryley/neoai.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  cmd = {
    "NeoAI",
    "NeoAIOpen",
    "NeoAIClose",
    "NeoAIToggle",
    "NeoAIContext",
    "NeoAIContextOpen",
    "NeoAIContextClose",
    "NeoAIInject",
    "NeoAIInjectCode",
    "NeoAIInjectContext",
    "NeoAIInjectContextCode",
  },
  keys = {
    { "<leader>as", desc = "summarize text" },
    { "<leader>ag", desc = "generate git message" },
  },
  opts = {
    models = {
      {
        name = "openai",
        model = "gpt-4.1",
      },
    },
    shortcuts = {
      {
        name = "textify",
        key = "<leader>as",
        desc = "fix text with AI",
        use_context = true,
        prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
        modes = { "v" },
        strip_function = nil,
      },
      {
        name = "gitcommit",
        key = "<leader>ag",
        desc = "generate git commit message",
        use_context = false,
        prompt = function()
          return [[
                  I want you to act as a commit message generator.
                  I will provide you the git diff, and I would like you to generate an appropriate commit message using the conventional commit format.
                  Do not write any explanations or other words, just reply with the commit message.
                ]] .. vim.fn.system("git diff --cached")
        end,
        modes = { "n" },
        strip_function = nil,
      },
    },
  },
}
