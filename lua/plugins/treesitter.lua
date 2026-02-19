return {
	{ -- Syntax-aware highlighting, indentation, folding, selection, and text objects
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- build: runs :TSUpdate after install/update to compile parsers

		dependencies = {
			-- Sticky context: pins enclosing function/class header to top of screen
			{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } },
			-- max_lines = 3: show at most 3 context lines (e.g. class > method > if)

			-- Text objects: syntax-aware selection and movement (af, if, ]f, etc.)
			"nvim-treesitter/nvim-treesitter-textobjects",
		},

		opts = {
			ensure_installed = {
				"bash",
				"css",
				"diff",
				"dockerfile",
				"graphql",
				"html",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"proto",
				"query",
				"scss",
				"sql",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			-- ensure_installed: parsers to pre-download on first launch
			--   'query' is for treesitter query files (useful for debugging highlights)
			--   'markdown_inline' handles code blocks inside markdown
			--   'diff' for git diff views
			--   'vimdoc' for :help files, 'luadoc' for lua doc comments

			auto_install = true,
			-- auto_install: when you open a file with no parser, install it on the fly

			highlight = {
				enable = true,
				-- enable: use treesitter for syntax highlighting instead of regex
				-- This also enables scope-aware spell checking (only flags
				-- misspellings in comments and strings, not variable names)
			},

			indent = {
				enable = true,
				-- enable: use treesitter for smart indentation (affects =, o, O, etc.)
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "v",
					-- init_selection: pressing v starts treesitter-aware selection
					--   (replaces default charwise visual mode entry)
					node_incremental = "<C-k>",
					-- node_incremental: expand selection to the next parent syntax node
					node_decremental = "<C-j>",
					-- node_decremental: shrink selection back to the previous child node
					scope_incremental = false,
					-- scope_incremental: disabled (would jump to the next scope, rarely useful)
				},
			},

			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					-- lookahead: if cursor isn't on a match, jump forward to the nearest one
					keymaps = {
						["af"] = { query = "@function.outer", desc = "around function" },
						["if"] = { query = "@function.inner", desc = "inside function" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "inside class" },
						["aa"] = { query = "@parameter.outer", desc = "around argument" },
						["ia"] = { query = "@parameter.inner", desc = "inside argument" },
					},
					-- Usage: 'daf' = delete a function, 'via' = select inside argument,
					--        'yac' = yank around class, etc.
				},

				move = {
					enable = true,
					set_jumps = true,
					-- set_jumps: add jumps to the jumplist (so <C-o> goes back)
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]a"] = { query = "@parameter.inner", desc = "Next argument" },
					},
					goto_next_end = {
						["]F"] = { query = "@function.outer", desc = "Next function end" },
					},
					goto_previous_start = {
						["[f"] = { query = "@function.outer", desc = "Prev function start" },
						["[a"] = { query = "@parameter.inner", desc = "Prev argument" },
					},
					goto_previous_end = {
						["[F"] = { query = "@function.outer", desc = "Prev function end" },
					},
					-- Note: ]c/[c are NOT used here because gitsigns already maps
					-- them for git hunk navigation
				},
			},
		},

		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},
}
