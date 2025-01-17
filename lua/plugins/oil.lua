return {
  { -- File explorer that allows navigating and editing directories as text buffers
    "stevearc/oil.nvim",
    -- For file icons
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      keymaps = {
        -- Need to remap C-h as it is used elsewhere for primary split navigation
        ["<C-h>"] = false,
        ["<C-x>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
      watch_for_changes = true,
    },
    init = function()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
