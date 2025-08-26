-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Show the current diagnostics (errors, warnings, etc) for the active buffer with <leader>q
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Move around splits with ctrl+direction (instead of ctrl+w direction)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left split' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right split' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower split' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper split' })

-- Disable horizontal scroll (and replace with shift+scroll)
vim.keymap.set({'n', 'v', 'i'}, '<ScrollWheelRight>', '<Nop>', { desc = 'Disable ScrollWheelRight' })
vim.keymap.set({'n', 'v', 'i'}, '<ScrollWheelLeft>', '<Nop>', { desc = 'Disable ScrollWheelLeft' })
vim.keymap.set({'n', 'v', 'i'}, '<S-ScrollWheelUp>', '<ScrollWheelRight>', { desc = 'Map Shift+ScrollWheelUp to ScrollWheelRight' })
vim.keymap.set({'n', 'v', 'i'}, '<S-ScrollWheelDown>', '<ScrollWheelLeft>', { desc = 'Map Shift+ScrollWheelDown to ScrollWheelLeft' })

-- Scroll one line at a time
vim.keymap.set({'n', 'v', 'i'}, '<ScrollWheelUp>', '<C-y>', { desc = 'Scroll up one line' })
vim.keymap.set({'n', 'v', 'i'}, '<ScrollWheelDown>', '<C-e>', { desc = 'Scroll down one line' })

-- Git
-- Prompts for commit message in vim's input()
vim.keymap.set('n', '<leader>gc', function()
    local msg = vim.fn.input('Commit message: ')
    if msg ~= '' then
        vim.cmd('!git commit -m ' .. vim.fn.shellescape(msg))
    end
end)

vim.keymap.set('n', '<leader>gP', ':!git pull<CR>')
vim.keymap.set('n', '<leader>gp', ':!git push origin<CR>')
vim.keymap.set('n', '<leader>gr', ':!git rebase green<CR>')
vim.keymap.set('n', '<leader>ga', ':!git add .<CR>')
vim.keymap.set('n', '<leader>gf', ':split | terminal git fetch origin green:green<CR>')
