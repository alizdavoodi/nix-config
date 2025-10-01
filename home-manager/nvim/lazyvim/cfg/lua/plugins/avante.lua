return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  -- keys = function(_, keys)
  --   ---@type avante.Config
  --   local opts =
  --     require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)
  --
  --   local mappings = {
  --     {
  --       opts.mappings.ask,
  --       function()
  --         require("avante.api").ask()
  --       end,
  --       desc = "avante: ask",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       opts.mappings.refresh,
  --       function()
  --         require("avante.api").refresh()
  --       end,
  --       desc = "avante: refresh",
  --       mode = "v",
  --     },
  --     {
  --       opts.mappings.edit,
  --       function()
  --         require("avante.api").edit()
  --       end,
  --       desc = "avante: edit",
  --       mode = { "n", "v" },
  --     },
  --   }
  --   mappings = vim.tbl_filter(function(m)
  --     return m[1] and #m[1] > 0
  --   end, mappings)
  --   return vim.list_extend(mappings, keys)
  -- end,
  opts = {
    {
      mappings = {
        ask = "<leader>as", -- ask
        edit = "<leader>ae", -- edit
        refresh = "<leader>ar", -- refresh
      },
    },
    -- add any opts here
    -- for example
    -- provider = "openai",
    -- openai = {
    --   endpoint = "https://api.openai.com/v1",
    --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
    --   timeout = 30000, -- timeout in milliseconds
    --   temperature = 0, -- adjust if needed
    --   max_tokens = 4096,
    --   -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
    -- },
    providers = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "anthropic/claude-3.7-sonnet",
      },
    },
    -- rag_service = {
    --   enabled = true, -- Enables the RAG service
    --   host_mount = os.getenv("HOME"), -- Host mount path for the rag service
    --   provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
    --   llm_model = "", -- The LLM model to use for RAG service
    --   embed_model = "", -- The embedding model to use for RAG service
    --   endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
    -- },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
