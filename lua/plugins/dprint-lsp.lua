-- Dprint LSP for formatting + Stylua for Lua files
-- No external plugins required; uses vim.lsp.start() directly.

local dprint_fts = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
	"json",
	"jsonc",
	"markdown",
	"yaml",
	"html",
	"css",
	"scss",
}

local group = vim.api.nvim_create_augroup("Formatting", { clear = true })

-- Start dprint as an LSP for every supported filetype.
-- vim.lsp.start() is idempotent: it reuses an existing client when
-- name + root_dir match, so opening many buffers in the same project
-- shares a single dprint process.
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = dprint_fts,
	callback = function(args)
		vim.lsp.start({
			name = "dprint",
			cmd = { "/opt/homebrew/bin/dprint", "lsp" },
			root_dir = vim.fs.root(args.buf, { "dprint.json", "dprint.jsonc", ".git" })
				or vim.fn.getcwd(),
		})
	end,
})

-- Format on save for dprint filetypes (filter to dprint client only).
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = {
		"*.js", "*.jsx", "*.ts", "*.tsx",
		"*.json", "*.jsonc",
		"*.md", "*.markdown",
		"*.yaml", "*.yml",
		"*.html", "*.css", "*.scss",
	},
	callback = function()
		vim.lsp.buf.format({ name = "dprint", timeout_ms = 3000 })
	end,
})

----------------------------------------------------------------------------
-- Stylua for Lua files
----------------------------------------------------------------------------
local function format_with_stylua()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local input = table.concat(lines, "\n") .. "\n"
	local result = vim.fn.system({ "stylua", "-" }, input)
	if vim.v.shell_error == 0 then
		local new_lines = vim.split(result, "\n")
		-- stylua output ends with \n, producing a trailing empty string
		if #new_lines > 0 and new_lines[#new_lines] == "" then
			table.remove(new_lines)
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = "*.lua",
	callback = format_with_stylua,
})

----------------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------------

-- <leader>f  –  format the current buffer
vim.keymap.set("n", "<leader>f", function()
	if vim.tbl_contains(dprint_fts, vim.bo.filetype) then
		vim.lsp.buf.format({ name = "dprint", timeout_ms = 3000 })
	elseif vim.bo.filetype == "lua" then
		format_with_stylua()
	end
end, { desc = "[F]ormat buffer" })

-- <leader>F  –  save without formatting (skips all BufWritePre autocmds)
vim.keymap.set("n", "<leader>F", "<cmd>noautocmd w<cr>", { desc = "Save without [F]ormatting" })

return {}
