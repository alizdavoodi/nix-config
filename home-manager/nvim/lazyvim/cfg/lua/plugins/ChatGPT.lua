return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  opts = {
    openai_params = {
      model = "gpt-4-1106-preview",
      frequency_penalty = 0,
      presence_penalty = 0,
      max_tokens = 300,
      temperature = 0.4,
      top_p = 1,
      n = 1,
    },
    openai_edit_params = {
      model = "gpt-4-1106-preview",
      temperature = 0.4,
      top_p = 1,
      n = 1,
    },
    popup_input = {
      submit = "<C-e>",
    },
    chat = {
      keymaps = {
        close = { "jk", "kj", "<Esc>" },
        yank_last = "<C-y>",
        scroll_up = "<C-u>",
        scroll_down = "<C-d>",
        toggle_settings = "<C-o>",
        new_session = "<C-n>",
        cycle_windows = "<Tab>",
      },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
