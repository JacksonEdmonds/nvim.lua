local opt = vim.opt

-- Display line numbers
opt.number = true
-- Show relative line numbers
opt.relativenumber = true

-- todo possibly set to foldmethod=syntax if I can get syntax folding working properly
-- Set fold level based on indent
opt.foldmethod = "indent"

-- Default folds to open when opening a file
opt.foldlevel = 99

-- todo determine if keeping statusline, if not set to true
-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	opt.clipboard = "unnamedplus"
end)

-- Don't wrap lines
opt.wrap = false

-- Save undo history in a file on disk (allows for restoring undo history when re-opening a file)
opt.undofile = true

-- Case-insensitive searching unless there is a capital letter in the search term
opt.ignorecase = true
opt.smartcase = true

-- Always show signcolumn (gutter to the left of line numbers that can contain symbols from plugins like git marks or breakpoints)
opt.signcolumn = "yes"

-- Decrease update time for faster completion
opt.updatetime = 250

-- Displays which-key popup immediately
opt.timeoutlen = 0

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Use special symbols to identify certain whitespace characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Always show these symbols rather than whitespace
opt.list = true

-- Highlight the line that the cursor is currently on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 5

-- Set tabs to 2 columns in width
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Enable spellchecking
opt.spell = true
opt.spelllang = "en"

-- Don't update the display while executing macros
opt.lazyredraw = true

-- Show proposed changes from substitutions in real time
opt.inccommand = "split"

-- Shared data settings
-- - ! : Save and restore user-defined global variables
-- - % : Save and restore information about buffers, including their file names. This allows reopening files you had open in the last session.
-- - '200 : Save up to 200 lines of each register
-- - /500 : Save up to 500 items from the search history
-- - :500 : Save up to 500 items from the command-line history
-- - <200 : Save the file marks (locations in files) for up to 200 file
-- - h : Don't persist the hlsearch state between sessions
-- - s500 : Save up to 500 items in the search pattern history (eg from :%s
opt.shada = "!,%,'200,/500,:500,<200,h,s500"

