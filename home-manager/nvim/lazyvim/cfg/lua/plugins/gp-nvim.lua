return {
  "robitx/gp.nvim",
  config = function()
    local config = {
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
