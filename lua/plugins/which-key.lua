-- A keybinding helper that shows a popup with available key bindings after pressing a leader key

return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Load immediately after entering Vim, before all UI elements are loaded
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>g', group = '[G]it' },
        { '<leader>gl', group = 'Git [L]og' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]orkspace' },
      }
    end,
  },
}
