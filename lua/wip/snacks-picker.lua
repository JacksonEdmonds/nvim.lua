-- Fuzzy finder with built-in smart file ranking (modern, Lua-native)
--
-- Uses snacks.nvim picker module by folke (same author as lazy.nvim, which-key).
-- Includes a smart file finder with frecency-like behaviour out of the box.
-- Lua-based matching (not as fast as fzf binary on very large candidate sets).
--
-- NOTE: snacks.picker API is relatively new and may change. Verify function
-- names against the latest docs if anything fails to load.
--
-- To activate: move this file to lua/plugins/ and move smart-open.lua to lua/wip/

return {
  {
    "folke/snacks.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      local snacks = require("snacks")

      snacks.setup({
        picker = {
          -- Replaces vim.ui.select() with snacks picker
          ui_select = true,
        },
      })

      -- Smart file finding (frecency-like ranking)
      vim.keymap.set("n", "<leader>sf", function() snacks.picker.smart() end, { desc = "[S]earch [F]iles (smart)" })

      -- Grep
      vim.keymap.set("n", "<leader>sg", function() snacks.picker.grep() end, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sw", function() snacks.picker.grep_word() end, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>s/", function() snacks.picker.grep_buffers() end, { desc = "[S]earch [/] in open files" })

      -- Navigation
      vim.keymap.set("n", "<leader>sh", function() snacks.picker.help() end, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", function() snacks.picker.keymaps() end, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sd", function() snacks.picker.diagnostics() end, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", function() snacks.picker.resume() end, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", function() snacks.picker.recent() end, { desc = "[S]earch recent files" })
      vim.keymap.set("n", "<leader>ss", function() snacks.picker.pickers() end, { desc = "[S]earch [S]elect picker" })
      vim.keymap.set("n", "<leader><leader>", function() snacks.picker.buffers() end, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader>/", function() snacks.picker.lines() end, { desc = "Fuzzy search in current buffer" })
      vim.keymap.set("n", "<leader>sn", function()
        snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })

      -- Git
      vim.keymap.set("n", "<leader>glc", function() snacks.picker.git_log() end, { desc = "Git [l]og [c]ommits" })
      vim.keymap.set("n", "<leader>glb", function() snacks.picker.git_log_file() end, { desc = "Git [l]og [b]uffer commits" })
      vim.keymap.set("n", "<leader>gb", function() snacks.picker.git_branches() end, { desc = "Git [b]ranches" })
      vim.keymap.set("n", "<leader>gs", function() snacks.picker.git_status() end, { desc = "Git [s]tatus" })
      vim.keymap.set("n", "<leader>gS", function() snacks.picker.git_stash() end, { desc = "Git [S]tash" })
    end,
  },
}
