-- Formatting pipeline: ESLint auto-fix → dprint format → stylua (Lua).
-- No external plugins required; uses vim.lsp.start() and shell commands directly.
-- This file lives in lua/plugins/ so lazy.nvim loads it, but returns {}
-- because no plugin needs to be installed.

local has_dprint = vim.fn.executable("dprint") == 1
local has_stylua = vim.fn.executable("stylua") == 1

if not has_dprint then
	vim.notify_once("dprint not found – install with: brew install dprint", vim.log.levels.WARN)
end
if not has_stylua then
	vim.notify_once("stylua not found – install with: brew install stylua (or via Mason)", vim.log.levels.WARN)
end

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

local eslint_fts = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

local group = vim.api.nvim_create_augroup("Formatting", { clear = true })

----------------------------------------------------------------------------
-- Dprint LSP
----------------------------------------------------------------------------
-- Start dprint as an LSP for every supported filetype.
-- vim.lsp.start() is idempotent: it reuses an existing client when
-- name + root_dir match, so opening many buffers in the same project
-- shares a single dprint process.
if has_dprint then
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = dprint_fts,
		callback = function(args)
			vim.lsp.start({
				name = "dprint",
				cmd = { "dprint", "lsp" },
				root_dir = vim.fs.root(args.buf, { "dprint.json", "dprint.jsonc", ".git" })
					or vim.fn.getcwd(),
			})
		end,
	})
end

----------------------------------------------------------------------------
-- Format on save: ESLint fix (code quality) → dprint format (whitespace)
----------------------------------------------------------------------------
-- Both steps are synchronous in BufWritePre so the buffer is fully
-- fixed + formatted before the write hits disk.
-- ESLint uses pcall because the server may not be attached (no eslint
-- config in the project, or the LSP hasn't started yet).
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
		if vim.tbl_contains(eslint_fts, vim.bo.filetype) then
			pcall(vim.cmd, "EslintFixAll")
		end
		if has_dprint then
			vim.lsp.buf.format({ name = "dprint", timeout_ms = 3000 })
		end
	end,
})

----------------------------------------------------------------------------
-- Stylua for Lua files
----------------------------------------------------------------------------
local function format_with_stylua()
	if not has_stylua then
		return
	end
	local buf = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local input = table.concat(lines, "\n") .. "\n"
	local result = vim.fn.system({ "stylua", "-" }, input)
	if vim.v.shell_error == 0 then
		local new_lines = vim.split(result, "\n")
		if #new_lines > 0 and new_lines[#new_lines] == "" then
			table.remove(new_lines)
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
		local max_line = vim.api.nvim_buf_line_count(buf)
		cursor[1] = math.min(cursor[1], max_line)
		vim.api.nvim_win_set_cursor(0, cursor)
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

vim.keymap.set("n", "<leader>f", function()
	if vim.tbl_contains(dprint_fts, vim.bo.filetype) then
		if vim.tbl_contains(eslint_fts, vim.bo.filetype) then
			pcall(vim.cmd, "EslintFixAll")
		end
		if has_dprint then
			vim.lsp.buf.format({ name = "dprint", timeout_ms = 3000 })
		end
	elseif vim.bo.filetype == "lua" then
		format_with_stylua()
	end
end, { desc = "[F]ormat buffer" })

vim.keymap.set("n", "<leader>F", "<cmd>noautocmd w<cr>", { desc = "Save without [F]ormatting" })

return {}
