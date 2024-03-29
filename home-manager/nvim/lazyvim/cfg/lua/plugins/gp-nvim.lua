return {
  "robitx/gp.nvim",
  branch = "copilot",
  config = function()
    local config = {
      agents = {
        {
          name = "ChatGPT4-Turbo",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4-turbo-preview", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
        {
          name = "CodeGPT4-Turbo",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4-turbo-preview", temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are an AI working as a code editor.\n\n"
            .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
            .. "START AND END YOUR ANSWER WITH:\n\n```",
        },
        {
          provider = "anthropic",
          name = "ChatClaude-3-Opus",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "claude-3-opus-20240229", temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
        {
          provider = "anthropic",
          name = "CodeClaude-3-Opus",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "claude-3-opus-20240229", temperature = 0.8, top_p = 1 },
          system_prompt = "You are an AI working as a code editor.\n\n"
            .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
            .. "START AND END YOUR ANSWER WITH:\n\n```",
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

          gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
        end,
      },
    }

    require("gp").setup(config)
  end,
}
