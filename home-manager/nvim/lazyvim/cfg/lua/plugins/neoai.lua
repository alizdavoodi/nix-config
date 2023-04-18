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
  config = function()
    require("neoai").setup({
      models = {
        {
          name = "openai",
          model = "gpt-4",
        },
      },
    })
  end,
}
