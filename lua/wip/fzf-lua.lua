-- Fuzzy finder with maximum matching speed via external fzf binary (compiled Go)
--
-- Uses fzf-lua as the picker framework. All fuzzy matching is delegated to the
-- fzf binary, making this the fastest option for very large codebases.
-- No frecency-based file ranking -- files are found by name/content only.
--
-- To activate: move this file to lua/plugins/ and move smart-open.lua to lua/wip/

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter", -- load early so register_ui_select() is available
    config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
        -- Floating window dimensions and preview pane behaviour
        winopts = {
          height = 0.85,
          width = 0.80,
          preview = {
            layout = "flex", -- horizontal on wide terminals, vertical on narrow
            flip_columns = 120, -- switch to vertical when terminal < 120 columns
            scrollbar = false,
          },
        },

        -- Options passed directly to the fzf binary
        fzf_opts = {
          ["--layout"] = "reverse", -- prompt at top, results below
        },

        -- Key bindings inside the picker.
        -- "builtin" keys are handled by fzf-lua (Neovim side).
        -- "fzf" keys are handled by the fzf binary (terminal side).
        -- Both are needed because some actions live on different sides.
        keymap = {
          builtin = {
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
            -- Send all results to quickfix for :cfdo operations
            ["ctrl-q"] = "select-all+accept",
          },
        },

        files = {
          cwd_prompt = false, -- hide cwd from the prompt (cleaner)
        },

        grep = {
          -- Enable glob filtering after a -- separator in live grep.
          -- Example: "myFunction -- *.ts" only searches TypeScript files.
          rg_glob = true,
        },

        lsp = {
          async_or_timeout = 5000, -- wait up to 5s for LSP responses
          symbols = {
            symbol_style = 1, -- show icon + kind next to symbol name
          },
        },
      })

      -- Replace vim.ui.select() with fzf-lua (for LSP code actions, etc.)
      fzf.register_ui_select()

      -- File finding
      vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })

      -- Grep
      vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sW", fzf.grep_cWORD, { desc = "[S]earch current [W]ORD" })
      vim.keymap.set("n", "<leader>s/", function()
        local bufnrs = vim.tbl_filter(function(buf)
          return vim.api.nvim_buf_is_loaded(buf)
            and vim.api.nvim_buf_get_name(buf) ~= ""
            and vim.bo[buf].buftype == ""
        end, vim.api.nvim_list_bufs())
        local paths = vim.tbl_map(vim.api.nvim_buf_get_name, bufnrs)
        fzf.live_grep({ search_paths = paths })
      end, { desc = "[S]earch [/] in open files" })

      -- Navigation
      vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sd", fzf.diagnostics_workspace, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = "[S]earch recent files" })
      vim.keymap.set("n", "<leader>ss", fzf.builtin, { desc = "[S]earch [S]elect picker" })
      vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "Fuzzy search in current buffer" })
      vim.keymap.set("n", "<leader>sn", function()
        fzf.files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })

      -- Git
      vim.keymap.set("n", "<leader>glc", fzf.git_commits, { desc = "Git [l]og [c]ommits" })
      vim.keymap.set("n", "<leader>glb", fzf.git_bcommits, { desc = "Git [l]og [b]uffer commits" })
      vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git [b]ranches" })
      vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git [s]tatus" })
      vim.keymap.set("n", "<leader>gS", fzf.git_stash, { desc = "Git [S]tash" })
    end,
  },
}
