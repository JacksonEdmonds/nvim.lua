-- Fuzzy finder with smart file ranking (frecency + proximity + LSP-aware)
--
-- Uses Telescope as the picker framework with smart-open for intelligent file finding.
-- smart-open blends fuzzy match quality with frecency (how often/recently you open files),
-- proximity (files near your current buffer), and LSP context into a single score.
--
-- To swap to fzf-lua or snacks.picker:
-- 1. Move this file to lua/wip/
-- 2. Move the desired alternative from lua/wip/ to lua/plugins/

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter", -- load early so ui-select is available for LSP code actions etc.
    dependencies = {
      "nvim-lua/plenary.nvim", -- utility library required by Telescope
      {
        -- Compiled C implementation of the fzf matching algorithm for Telescope.
        -- Much faster than Telescope's default Lua sorter on large result sets.
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      -- Replaces vim.ui.select() with a Telescope dropdown so LSP code actions,
      -- test pickers, etc. use Telescope's fuzzy UI instead of a numbered menu.
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
      {
        -- Frecency + proximity + LSP-aware file finder.
        -- Ranks candidates by blending fuzzy match quality with how often/recently
        -- you open the file, how close it is to your current buffer, and whether
        -- it contains symbols relevant to your current context.
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        dependencies = { "kkharji/sqlite.lua" }, -- frecency database
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          -- Adapt layout to terminal width: horizontal preview on wide terminals,
          -- vertical on narrow ones (e.g. when Neovim is in a split)
          layout_strategy = "flex",
          layout_config = {
            -- Switch from horizontal to vertical when terminal is narrower than this
            flex = { flip_columns = 120 },
            horizontal = { preview_width = 0.5 },
            vertical = { preview_height = 0.5 },
          },
          mappings = {
            i = {
              -- Send all results to the quickfix list for bulk operations.
              -- Workflow: grep for a pattern → <C-q> → :cfdo %s/old/new/gc | update
              ["<C-q>"] = function(prompt_bufnr)
                actions.send_to_qflist(prompt_bufnr)
                actions.open_qflist(prompt_bufnr)
              end,
            },
            n = {
              ["<C-q>"] = function(prompt_bufnr)
                actions.send_to_qflist(prompt_bufnr)
                actions.open_qflist(prompt_bufnr)
              end,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            -- Use a compact dropdown theme for vim.ui.select (code actions etc.)
            require("telescope.themes").get_dropdown(),
          },
          smart_open = {
            -- Use the fzf algorithm (from telescope-fzf-native) for matching.
            -- Faster and more intuitive than the default "fzy" algorithm.
            match_algorithm = "fzf",
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "smart_open")

      -- Smart file finding (frecency + proximity + LSP-aware ranking)
      vim.keymap.set("n", "<leader>sf", function()
        telescope.extensions.smart_open.smart_open()
      end, { desc = "[S]earch [F]iles (smart)" })

      -- Grep
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sW", function()
        builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
      end, { desc = "[S]earch current [W]ORD" })
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in open files" })

      -- Navigation
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch recent files" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect picker" })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10, -- slight transparency
          previewer = false, -- no preview needed for single-buffer search
        }))
      end, { desc = "Fuzzy search in current buffer" })
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })

      -- Git
      vim.keymap.set("n", "<leader>glc", builtin.git_commits, { desc = "Git [l]og [c]ommits" })
      vim.keymap.set("n", "<leader>glb", builtin.git_bcommits, { desc = "Git [l]og [b]uffer commits" })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git [b]ranches" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git [s]tatus" })
      vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Git [S]tash" })
    end,
  },
}
