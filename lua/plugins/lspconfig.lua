-- LSP configuration: language servers, Mason installer, diagnostics, and keymaps.
--
-- Servers: vtsls (TypeScript/JS), eslint, cssls, html, jsonls, lua_ls.
-- Mason auto-installs all servers and tools on first launch.
-- Keymaps are picker-agnostic: prefer Telescope → fzf-lua → vim.lsp.buf fallback.

return {
	{
		-- Lua LSP setup for Neovim config/plugin development.
		-- Provides completions, annotations, and signatures for vim.*, vim.api.*, etc.
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	-- Type stubs for Luv (libuv bindings used by vim.uv)
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- LSP progress spinner in the bottom-right corner
			{ "j-hui/fidget.nvim", opts = {} },
			-- JSON/YAML schema catalog (tsconfig.json, package.json, etc.)
			"b0o/SchemaStore.nvim",
		},
		config = function()
			-- Picker-agnostic helper: tries Telescope, then fzf-lua, then vim.lsp.buf.
			-- When you swap picker plugins, LSP keymaps automatically use whichever is loaded.
			local function lsp_pick(telescope_fn, fzf_fn, fallback)
				return function()
					local ok, mod = pcall(require, "telescope.builtin")
					if ok and mod[telescope_fn] then
						return mod[telescope_fn]()
					end
					ok, mod = pcall(require, "fzf-lua")
					if ok and mod[fzf_fn] then
						return mod[fzf_fn]()
					end
					fallback()
				end
			end

			vim.diagnostic.config({
				float = { border = "rounded", source = true },
				severity_sort = true,
			})

			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Navigation
					map("gd", lsp_pick("lsp_definitions", "lsp_definitions", vim.lsp.buf.definition), "[G]oto [D]efinition")
					map("gr", lsp_pick("lsp_references", "lsp_references", vim.lsp.buf.references), "[G]oto [R]eferences")
					map("gI", lsp_pick("lsp_implementations", "lsp_implementations", vim.lsp.buf.implementation), "[G]oto [I]mplementation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("<leader>D", lsp_pick("lsp_type_definitions", "lsp_typedefs", vim.lsp.buf.type_definition), "Type [D]efinition")
					map("<leader>ds", lsp_pick("lsp_document_symbols", "lsp_document_symbols", vim.lsp.buf.document_symbol), "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						lsp_pick("lsp_dynamic_workspace_symbols", "lsp_live_workspace_symbols", vim.lsp.buf.workspace_symbol),
						"[W]orkspace [S]ymbols"
					)

					-- Actions
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v" })

					-- Document highlight: subtly highlight other references to the symbol
					-- under the cursor after a brief pause (CursorHold, controlled by updatetime)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Inlay hints: show inferred types, parameter names etc. inline.
					-- Off by default because they shift your code rightward.
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Build LSP capabilities. If nvim-cmp is installed, merge its extra
			-- capabilities (snippet support, additional completion item kinds).
			-- Falls back to plain defaults until cmp is configured.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local has_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if has_cmp_lsp then
				capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
			end

			-- Server configs: keys are lspconfig names, values override defaults.
			-- An empty table {} means "use lspconfig defaults, no overrides."
			local servers = {
				-- Fastest TypeScript/JavaScript server (wraps tsserver with a more
				-- efficient wire protocol than ts_ls)
				vtsls = {},
				-- ESLint as an LSP: real-time diagnostics + code actions + EslintFixAll
				eslint = {},
				cssls = {},
				html = {},
				jsonls = {
					settings = {
						json = {
							-- Auto-validate tsconfig.json, package.json, etc. against
							-- their official schemas from SchemaStore.org
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								-- Show full function signatures in completion, not just names
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
