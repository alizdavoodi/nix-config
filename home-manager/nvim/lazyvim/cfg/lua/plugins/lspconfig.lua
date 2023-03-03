return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { { "someone-stole-my-name/yaml-companion.nvim" } },
    opts = {
      diagnostics = {
        virtual_text = false,
      },
      setup = {
        yamlls = function()
          local cfg = require("yaml-companion").setup({

            -- Add any options here, or leave empty to use the default settings
            -- lspconfig = {
            --   cmd = {"yaml-language-server"}
            -- },
            --
            -- Built in file matchers
            builtin_matchers = {
              -- Detects Kubernetes files based on content
              kubernetes = { enabled = true },
              cloud_init = { enabled = true },
            },

            -- Additional schemas available in Telescope picker
            schemas = {
              result = {
                --{
                --  name = "Kubernetes 1.22.4",
                --  uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
                --},
                -- {
                --   name = "Gitlab-ci",
                --   url = "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"
                -- }
              },
            },

            -- Pass any additional options that will be merged in the final LSP config
            lspconfig = {
              flags = {
                debounce_text_changes = 150,
              },
              settings = {
                redhat = { telemetry = { enabled = false } },
                yaml = {
                  validate = true,
                  format = { enable = true },
                  hover = true,
                  schemaStore = {
                    enable = true,
                    url = "https://www.schemastore.org/api/json/catalog.json",
                  },
                  schemaDownload = { enable = true },
                  schemas = {},
                  trace = { server = "debug" },
                  customTags = {
                    "!reference sequence",
                    "!And scalar",
                    "!And mapping",
                    "!And sequence",
                    "!If scalar",
                    "!If mapping",
                    "!If sequence",
                    "!Not scalar",
                    "!Not mapping",
                    "!Not sequence",
                    "!Equals scalar",
                    "!Equals mapping",
                    "!Equals sequence",
                    "!Or scalar",
                    "!Or mapping",
                    "!Or sequence",
                    "!FindInMap scalar",
                    "!FindInMap mappping",
                    "!FindInMap sequence",
                    "!Base64 scalar",
                    "!Base64 mapping",
                    "!Base64 sequence",
                    "!Cidr scalar",
                    "!Cidr mapping",
                    "!Cidr sequence",
                    "!Ref scalar",
                    "!Ref mapping",
                    "!Ref sequence",
                    "!Sub scalar",
                    "!Sub mapping",
                    "!Sub sequence",
                    "!GetAtt scalar",
                    "!GetAtt mapping",
                    "!GetAtt sequence",
                    "!GetAZs scalar",
                    "!GetAZs mapping",
                    "!GetAZs sequence",
                    "!ImportValue scalar",
                    "!ImportValue mapping",
                    "!ImportValue sequence",
                    "!Select scalar",
                    "!Select mapping",
                    "!Select sequence",
                    "!Split scalar",
                    "!Split mapping",
                    "!Split sequence",
                    "!Join scalar",
                    "!Join mapping",
                    "!Join sequence",
                  },
                },
              },
            },
          })

          require("lspconfig")["yamlls"].setup(cfg)
          return true
        end,
      },
    },
  },
}
