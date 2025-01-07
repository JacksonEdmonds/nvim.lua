Windows
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
win32yank

Linux
sudo apt install make gcc ripgrep unzip git xclip curl

Mac
???

A nerd font should be set as the default font within the terminal

# Tutorials

How I setup nvim - https://www.youtube.com/watch?v=6pAG3BHurdM

Complete:

- https://youtu.be/Gs1VDYnS-Ac?si=eJoybEHYLVMI9WqS&t=2021
- https://www.youtube.com/watch?v=XA2WjJbmmoM

https://www.youtube.com/playlist?list=PL0tgH22U2S3GN7MdobsdWV44qw-P5g7RJ
https://www.youtube.com/watch?v=zHTeCSVAFNY

- 1.5h nvim LSP
  - mason.nvim is responsible for installing language servers
  - nvim-lspconfig configures language servers
  - nvim-cmp is an autocompletion engine
- 1.5h nvim General setup - https://www.youtube.com/watch?v=6pAG3BHurdM
- 10min nvim Debugging - https://www.youtube.com/watch?v=lyNfnI-B640
- Setup Nvim - C:\Users\Jackson\AppData\Local\nvim
- https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#csv-files
- https://github.com/qpkorr/vim-renamer
- Update package.csv for vim, neovim and VSCode

# Review plugins

Done:
- indent_line
- colorschemes

## lspconfig

Controls the communication between the LSP and NVIM

How can I show suggestions for errors?

### mason

Installs typescript-language-server
This is automated with mason-lspconfig
?Is there a better typescript lsp I could be using?

todo:
- cmp: A completion engine for Neovim, providing a powerful and customizable autocomplete framework that supports multiple completion sources (like LSP, buffer words, paths, and more).
- conform: A lightweight, on-demand code formatting plugin for Neovim, supporting a variety of languages and formatter tools.
- dadbod: A database client for Neovim, allowing users to interact with various database systems directly within the editor.
- debug: Debugging tools integrated with Neovim, often working alongside other tools like DAP (Debug Adapter Protocol) to offer breakpoints, stepping, and variable inspection.
- gitsigns: Git integration for Neovim, adding features like inline git diff signs, hunk management, and other version control utilities.
- lint: A linting framework for Neovim that runs linters on various programming languages and provides feedback within the editor.
- mini: A collection of small, independent Neovim plugins providing various enhancements like statusline, surround text manipulation, and auto-pairs, all in a minimalist package.
- neo-tree: A file explorer for Neovim, offering an interactive and customizable interface for navigating and managing files within a project.
- oil: A file explorer plugin that allows navigating and editing directories as text buffers, providing an alternative way to manage files in Neovim.
- telescope: A fuzzy finder for Neovim that allows fast searching through files, buffers, LSP symbols, git commits, and more with a highly customizable interface.
- todo-comments: A plugin to highlight and manage TODO comments in code, helping users easily track tasks and notes within their projects.
- treesitter: A syntax parser that offers advanced syntax highlighting, code navigation, and other language-specific features for Neovim, improving code comprehension and editing experience.
- which-key: A keybinding helper that shows a popup with available key bindings in Neovim after pressing a leader key, helping users discover keymaps without memorizing them all.
- nvim-tree: sidebar file manager
- mini files: floating file manager

# Fuzzy Finding

Is there a better way of going to or opening a file than :find?
When using :find (or some other option), do I need to set my path to the workspace, eg: path=.,\*\*

Search by file name
Search by file contents (and limit to specific directory/file type)

## Telescope

`<Ctrl> + /` - show actions that can be taken within the current telescope picker

## FZF

# Syntax highlighting/LSP

" Enable syntax highlighting
syntax enable

May need to play around with auto indenting
autoindent
cindent
smartindent

" Allow for tab autocomplete of settings (complete to the next full match, after which show list of all potential matches)
set wildmode=longest,list
set wildmenu

Click function to go to definition/usage

- `gd` - go to definition
- `gr` - go to references

Function hints on hover - `K`
Autocomplete suggestions based on types - nvim-cmp
AI line autocompletion

Autocomplete setup - https://www.youtube.com/watch?v=22mrSjknDHI

Mason

nvim-cmp

## treesitter

:TSInstall
bash
c
css
diff
dockerfile
git_config
gitattributes
gitignore
graphql
html
java
javascript
json
markdown
proto
python
rust
sql
toml
typescript

# Formatting & Linting

## dprint

https://www.youtube.com/watch?v=ybUE4D80XSk

https://github.com/dprint/dprint-plugin-prettier
https://github.com/dprint/dprint-plugin-typescript
Lint on save - conform.nvim

# Git

Git in nvim - https://medium.com/@shaikzahid0713/git-integration-in-neovim-a6f26c424b58

Side by side commit differences

# Status line

Currently handled by mini.lua

" Always show the status line
set laststatus=2

" Set the status line the way I like it
set stl=%f\ %m\ %R\ %y\ %=%l\/%L\:\%c\ [%p%%]\ 0x\%-3B

%f: File name.
%m: Modified flag (shows + if the file has been modified).
%R: Read-only flag (shows RO if the file is read-only).
%y: File type.
%=: Left-right separator (places the following elements on the right side).
%l: Current line number.
%L: Total number of lines.
%c: Current column number.
[%p%%]: Percentage through the file.
0x%-3B: Byte value of the character under the cursor, in hexadecimal.

hide duplicate search results count - in statusline and bottom bar

# Buffers

Save open buffers on close and restore on next open

Show open buffers

Dealing with terminal - run within nvim? Have in a separate terminal tab/split?

Tmux?

https://dev.to/iggredible/a-faster-vim-workflow-with-buffers-and-args-51kf
https://linuxhandbook.com/vim-buffers/

Autosave on buffer swap/change
vim.api.nvim_create_autocmd(
{ "FocusLost", "ModeChanged", "TextChanged", "BufEnter" },
{ desc = "autosave", pattern = "\*", command = "silent! update" }
)

# File Manager

vifm

## Oil - https://github.com/stevearc/oil.nvim

`-` - opens oil file manager or goes up a directory if oil is already open
`g.` - show hidden files
`g?` - show default keymaps

# Splits

create shortcut for resizing splits

# Opening links/following file references

https://github.com/chrishrb/gx.nvim

# Database Connection

## dadbod

https://github.com/tpope/vim-dadbod

Database

`:DBUI` - opens dadbod

cmp.setup.filetype({ 'sql' }, {
sources = {
{ name = 'vim-dadbod-completion' },
{ name = 'buffer' },
},
})

# Other plugins

- nvim easyjump
- flash.nvim
- https://github.com/ThePrimeagen/harpoon
  - split open mark/harpoon
- Something to do network requests?

# Other

- ctags
- errorformat
- :i - include search - search in files that have been imported by the current file
- Lazy update on launch

# Terminal

- Warp
- WezTerminal
- Alacritty

# Bazel

# Clicking Links

gx to open link under cursor gf to go to file under cursor, e.g. ../foo/bar

#

Use `:Lazy` to view current plugin status. Hit `q` to close the window.
Use `:Lazy update` to update all plugins
Use `<leader>q` to show quickfix list for current file

git clone https://github.com/JacksonEdmonds/nvim.lua {config}

nvim focussed lua reference - https://neovim.io/doc/user/lua-guide.html
lua reference - https://learnxinyminutes.com/docs/lua/

#

https://medium.com/@shaikzahid0713/the-neovim-series-32163eb1f5d0

https://github.com/nvim-telescope/telescope.nvim - fuzzy finder for files in the directory (and children) - Open with ctrl + p
https://github.com/nvim-telescope/telescope-fzf-native.nvim - Improve telescope performance
Alternate file - ctrl + ^ to swap to last file
Harpoon - leader + a to add file to harpoon list, ctrl + e to show all files in harpoon list
Undo tree
Fugitive - Git integration
https://github.com/nvim-treesitter/nvim-treesitter
nvim-treesitter-context - Keeps the function heading that you are working on pinned to the top of the page
https://github.com/williamboman/mason.nvim - Package manager for LSP servers
https://github.com/neovim/nvim-lspconfig - Quick start configs for the Nvim LSP client
https://github.com/rust-lang/rust-analyzer - Rust LSP
https://github.com/nvim-tree/nvim-tree.lua - File tree - open with ctrl + n

-- .config/nvim/lua/custom/chadrc.lua
local M = {}
M.ui = {theme = 'onedark'}
M.plugins = 'custom.plugins'
M.mappings = require "custom.mappings"
return M

-- .config/nvim/lua/custom/plugins.lua
local plugins = {
{
"williamboman/mason.nvim",
opts = {
ensuer*installed = {
-- Always install rust-analyzer LSP
"rust-analyzer",
},
},
},
{
-- overwrite some of the configs of nvim-lspconfig with our own custom config
"neovim/nvim-lspconfig",
config = function()
-- Default NVChad config
require "plugins.configs.lspconfig"
-- Our custom config
require "custom.configs.lspconfig"
end,
},
{
"rust-lang/rust.vim",
ft = "rust",
-- Run lua code on startup
init = function ()
-- Enable formatting on save for Rust files
vim.g.rustfmt_autosave = 1
end
},
{
"simrat39/rust-tools.nvim",
ft = "rust",
dependencies = "neovim/nvim-lspconfig"
opts = function ()
return require "custom.configs.rust-tools"
end,
config = function(*, opts)
require('rust-tools').setup(opts)
end
}
-- Requires lldb to installed on the system - debugger
{
"mfussenegger/nvim-dap",
}
}
return plugins

-- .config/nvim/lua/custom/configs/lspconfig.lua
-- Comes from NVChad
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
-- Neovim LSP config
local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

---- Ad rust analyzer to lspconfig table
--lspconfig.rust_analyzer.setup({
-- on_attach = on_attach,
-- capabilties = capabilities,
-- -- Only run on rust file types
-- filetypes = {"rust"},
-- -- For rust projects, set the root directory to be where Cargo.toml is
-- root_dir = util.root_pattern{"Cargo.toml"}
-- -- This helps with autocompletion for cargo crates
-- settings = {
-- ['rust-analyzer'] = {
-- cargo = {
-- allFeatures = true,
-- },
-- },
-- },
--})

-- .config/nvim/lua/custom/configs/rust-tools.lua
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local options = {
server = {
on_attach = on_attach,
capabilities = capabilities,
}
}

return options

-- .config/nvim/lua/custom/mappings.lua
local M = {}

M.dap = {
n = {
["<leader>db"] = {
"<cmd> DapToggleBreakpoint <CR>",
"Toggle breakpoint"
},
["<leader>dus"] = {
function ()
local widgets = require('dap.ui.widgets');
local sidebar = widgets.sidebar(widgets.scopes);
end,
}
}
}

return M

-- After opening Nvim
:MasonInstallAll
