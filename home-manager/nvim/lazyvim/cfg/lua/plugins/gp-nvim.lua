return {
  "robitx/gp.nvim",
  -- branch = "copilot",
  config = function()
    local config = {
      providers = {
        anthropic = {
          disable = false,
          endpoint = "https://api.anthropic.com/v1/messages",
          secret = os.getenv("ANTHROPIC_API_KEY"),
        },
      },
      agents = {
        {
          name = "ChatGPT4o",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4o", temperature = 0.4, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          name = "ChatOllama",
          chat = true,
          provider = "ollama",
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "llama3:8b" },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          name = "ChatCodeLlama",
          chat = true,
          provider = "ollama",
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "codellama:34b-instruct" },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          name = "CodeGPT4o",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4o", temperature = 0.4, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "anthropic",
          name = "ChatClaude-3-5-Sonnet",
          chat = true,
          command = false,
          model = { model = "claude-3-5-sonnet-20240620", temperature = 0.5, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          providers = "anthropic",
          name = "CodeClaude-3-5-Sonnet",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "claude-3-5-sonnet-20240620", temperature = 0.5, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
      },
      hooks = {
        Grammarly = function(gp, params)
          local agent = gp.get_command_agent()
          local template = "You are a machine that check grammar mistake and"
            .. "make the sentence more fluent. You take all the user input and auto"
            .. "correct it. Just reply to user input with correct grammar, DO NOT"
            .. "reply the context of the question of the user input. If the user"
            .. "input is grammatically correct and fluent, just reply with the exact same input.\n"
            .. "Also respect any non alphabetical characters and leave them as they are."
            .. "Keep the wrap line lenght to 80 characters.\n\n"
            .. "```{{selection}}\n```\n\n"

          gp.Prompt(params, gp.Target.rewrite, agent, template)
        end,
      },
    }

    require("gp").setup(config)
  end,
}
