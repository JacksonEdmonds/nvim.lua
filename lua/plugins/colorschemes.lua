return {
  {
    'navarasu/onedark.nvim',
    priority = 1000, -- Load this before all the other start plugins.
    config = function()
      require('onedark').setup {
        style = 'dark'
      }
      require('onedark').load()
    end,
  },
}