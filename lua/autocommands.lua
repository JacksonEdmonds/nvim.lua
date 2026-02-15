-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Automatically go to the last known cursor position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Autosave: autowriteall (in options.lua) handles buffer switches at the Vim
-- core level. This autocmd covers FocusLost (switching to another app / tmux
-- pane) which autowriteall does not. nested = true ensures BufWritePre
-- formatting still fires.
vim.api.nvim_create_autocmd('FocusLost', {
  group = vim.api.nvim_create_augroup('autosave', { clear = true }),
  nested = true,
  callback = function()
    if vim.bo.modified and vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
      vim.cmd('silent! write')
    end
  end,
})

-- Makefile requires real tabs (not spaces), override expandtab for make filetype
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('filetype-tabs', { clear = true }),
  pattern = { 'make' },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
