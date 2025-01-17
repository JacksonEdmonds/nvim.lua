## General

| Command | Description |
| ------- | ----------- |
| `gx` | Open link under cursor |
| `gf` | Go to file under cursor, eg `../foo/bar` |
| `:Lazy` | View current plugin status. Hit `q` to close the window |
| `:Lazy update` | Update all plugins |
| `<leader>q` | Show quickfix list for current file |
| `<C-^>` | Swap to last file |

## Oil

File explorer that allows navigating and editing directories as text buffers

| Command | Description |
| ------- | ----------- |
| `<C-s>` | Open in vertical split |
| `<C-x>` | Open in horizontal split (remapped from `<C-h>`) |
| `<C-t>` | Open in new tab |
| `<C-p>` | Show/hide file preview in horizontal split |
| `<C-c>` | Close oil and return to open file |
| `<C-l>` | Refresh |
| `-` | Go up a folder |
| `_` | Open current working directory |
| `` ` `` | Change current working directory (CWD) to be the current directory globally |
| `~` |  Change current working directory (CWD) to be the current directory for just this tab |
| `g?` | Show help |
| `gs` | Open sort by menu |
| `gx` | Open hovered in default external program |
| `g.` | Toggle hidden files |

## Gitsigns

| Command | Description |
| ------- | ----------- |
| `]c` | Jump to next git change |
| `[c` | Jump to previous git change |

# To Do

## which-key

https://github.com/folke/which-key.nvim

A keybinding helper that shows a popup with available key bindings in Neovim after pressing a leader key, helping users discover keymaps without memorizing them all.

## Tutorials/General

Pimp your terminal with Custom ZSH Themes & Prompts - https://www.youtube.com/watch?v=XSeO6nnlWHw

How I setup nvim - https://www.youtube.com/watch?v=6pAG3BHurdM

https://youtu.be/Gs1VDYnS-Ac?si=eJoybEHYLVMI9WqS&t=2021
https://www.youtube.com/watch?v=XA2WjJbmmoM

https://www.youtube.com/playlist?list=PL0tgH22U2S3GN7MdobsdWV44qw-P5g7RJ
https://www.youtube.com/watch?v=zHTeCSVAFNY

- 1.5h nvim General setup - https://www.youtube.com/watch?v=6pAG3BHurdM
- 10min nvim Debugging - https://www.youtube.com/watch?v=lyNfnI-B640
- Setup Nvim - C:\Users\Jackson\AppData\Local\nvim
- https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#csv-files
- https://github.com/qpkorr/vim-renamer

Autocomplete setup - https://www.youtube.com/watch?v=22mrSjknDHI

Move around terminal output with vi keys - https://stackoverflow.com/questions/72881532/zsh-vi-normal-mode-to-move-around-printed-text

## LSP

- mason.nvim is responsible for installing language servers
- nvim-lspconfig configures language servers
- nvim-cmp is an autocompletion engine

- https://github.com/pmizio/typescript-tools.nvim
- https://nvimdev.github.io/lspsaga/
- lspconfig
    - Controls the communication between the LSP and NVIM
    - How can I show suggestions for errors?
- mason
    - Installs typescript-language-server
    - This is automated with mason-lspconfig
    - ?Is there a better typescript lsp I could be using?

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
AI line autocompletion

### cmp

Already have base config

determine if necessary after implementing lsp

https://github.com/hrsh7th/nvim-cmp

A completion engine for Neovim, providing a powerful and customizable autocomplete framework that supports multiple completion sources (like LSP, buffer words, paths, and more).

### treesitter

Already have base config

determine if necessary after implementing lsp

https://github.com/nvim-treesitter/nvim-treesitter

A syntax parser that offers advanced syntax highlighting, code navigation, and other language-specific features for Neovim, improving code comprehension and editing experience.

nvim-treesitter-context - Keeps the function heading that you are working on pinned to the top of the page

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

### conform

Already have base config

determine if necessary after implementing lsp

https://github.com/stevearc/conform.nvim

A lightweight, on-demand code formatting plugin for Neovim, supporting a variety of languages and formatter tools.

## Fuzzy Finding

Is there a better way of going to or opening a file than :find?
When using :find (or some other option), do I need to set my path to the workspace, eg: path=.,\*\*

Search by file name
Search by file contents (and limit to specific directory/file type)

### Telescope

https://github.com/nvim-telescope/telescope.nvim

Already have a base config

A fuzzy finder for Neovim that allows fast searching through files, buffers, LSP symbols, git commits, and more with a highly customizable interface.

`<Ctrl> + /` - show actions that can be taken within the current telescope picker

https://github.com/nvim-telescope/telescope-fzf-native.nvim - Improve telescope performance

### FZF

## Formatting & Linting

### lint

https://github.com/mfussenegger/nvim-lint

Already have a base config

A linting framework for Neovim that runs linters on various programming languages and provides feedback within the editor.

### dprint

https://www.youtube.com/watch?v=ybUE4D80XSk

https://github.com/dprint/dprint-plugin-prettier
https://github.com/dprint/dprint-plugin-typescript
Lint/format on save - conform.nvim

prettier nvim configs to have max line length

## Git

Git in nvim - https://medium.com/@shaikzahid0713/git-integration-in-neovim-a6f26c424b58

Side by side commit differences

## Status line

Could be handled by mini.nvim

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

## Session manager

https://github.com/rmagatti/auto-session

## colorscheme for nvim and ghostty

https://ghostty.org/docs/features/theme

## Splits

nvim vs ghostty vs tmux splits

https://www.reddit.com/r/neovim/comments/1hne1q6/navigation_between_ghostty_and_neovim_splits/

## Buffers

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

## Git

git diff "watch"

Already using gitsigns

## ZSH

Zsh prompt - https://github.com/fosslife/awesome-ricing?tab=readme-ov-file#prompts
Zsh plugins - https://github.com/unixorn/awesome-zsh-plugins
Ghostty/nvim colorscheme - https://github.com/Everblush/everblush.vim, https://github.com/nathanbuchar/atom-one-dark-terminal/blob/master/screenshots/one-dark.png

## Commenting

Modify nvim built in commenting to have padding (ie space) - https://github.com/neovim/neovim/pull/28176

## General

Update tab/title based on file navigated to
Review vim keys - https://vim.rtorr.com
rebind keys

## Update package.csv for vim, neovim and VSCode

Windows
choco install -y neovim fd git gzip make mingw ripgrep unzip wget 
win32yank

Linux
sudo apt install neovim curl gcc git make ripgrep unzip xclip 

Mac
brew install neovim git ripgrep

A nerd font should be set as the default font within the terminal

## File Manager

Already using Oil

neo-tree: A file explorer for Neovim, offering an interactive and customizable interface for navigating and managing files within a project.
nvim-tree: sidebar file manager

## Splits

create shortcut for resizing splits

## debug

Already have base config

https://github.com/mfussenegger/nvim-dap

Debugging tools integrated with Neovim, often working alongside other tools like DAP (Debug Adapter Protocol) to offer breakpoints, stepping, and variable inspection.

["<leader>dus"] = {
    function ()
    local widgets = require('dap.ui.widgets');
    local sidebar = widgets.sidebar(widgets.scopes);
    end,
}

## mini

https://github.com/echasnovski/mini.statusline

## Undo tree

## Database Connection

### dadbod

https://github.com/tpope/vim-dadbod

Database

`:DBUI` - opens dadbod

cmp.setup.filetype({ 'sql' }, {
sources = {
{ name = 'vim-dadbod-completion' },
{ name = 'buffer' },
},
})

## Other plugins

- nvim easyjump
- flash.nvim
- https://github.com/ThePrimeagen/harpoon
  - split open mark/harpoon
- Something to do network requests?

## Other

- ctags
- errorformat
- :i - include search - search in files that have been imported by the current file
- Lazy update on launch

ls replacement - https://github.com/eza-community/eza
CLI Jira - https://github.com/go-jira/jira
CLI Slack? - https://github.com/jpbruinsslot/slack-term
CLI tools - https://github.com/k4m4/terminals-are-sexy?tab=readme-ov-file#tools-and-plugins, https://github.com/fosslife/awesome-ricing?tab=readme-ov-file#table-of-contents
Allow pasting images in nvim - https://www.yloutube.com/watch?v=0O3kqGwNzTI

## Bazel

## Lua reference

nvim focussed lua reference - https://neovim.io/doc/user/lua-guide.html
lua reference - https://learnxinyminutes.com/docs/lua/
