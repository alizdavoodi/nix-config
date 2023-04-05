-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
		vim.diagnostic.disable(bufnr)
		vim.defer_fn(function()
			vim.diagnostic.reset(nil, bufnr)
		end, 1000)
	end
	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		elseif vim.lsp.buf.formatting then
			vim.lsp.buf.formatting()
		end
	end, { desc = "Format current buffer with LSP" })
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "sumneko_lua", "ansiblels", "yamlls", "terraformls", "tflint", "bashls" },
})

require("lspconfig")["ansiblels"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		ansible = {
			path = "ansible",
		},
		ansibleLint = {
			enabled = true,
			path = "ansible-lint",
		},
		executionEnvironment = {
			enabled = false,
		},
		python = {
			interpreterPath = "python",
		},
	},
})
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

require("lspconfig").sumneko_lua.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

require("lspconfig").nil_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").bashls.setup({})
require("lspconfig").terraformls.setup({})
require("lspconfig").tflint.setup({})
