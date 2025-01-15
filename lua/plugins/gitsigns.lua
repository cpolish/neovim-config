return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, { desc = "Jump to next Git [c]hange" })

        map('n', "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, { desc = "Jump to previous Git [c]hange" })

        -- Actions
        -- visual mode
        map('v', "<leader>ghs", function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = "[G]it [s]tage hunk" })

        map('v', "<leader>ghr", function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = "[G]it [r]eset hunk" })

        -- normal mode
        map('n', "<leader>ghs", gitsigns.stage_hunk, { desc = "[G]it [s]tage hunk" })
        map('n', "<leader>ghr", gitsigns.reset_hunk, { desc = "[G]it [r]eset hunk" })
        map('n', "<leader>ghS", gitsigns.stage_buffer, { desc = "[G]it [S]tage buffer" })
        map('n', "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "[G]it [u]ndo stage hunk" })
        map('n', "<leader>ghR", gitsigns.reset_buffer, { desc = "[G]it [R]eset buffer" })
        map('n', "<leader>ghp", gitsigns.preview_hunk, { desc = "[G]it [p]review hunk" })
        map('n', "<leader>ghb", gitsigns.blame_line, { desc = "[G]it [b]lame line" })
        map('n', "<leader>ghd", gitsigns.diffthis, { desc = "[G]it [d]iff against index" })
        map('n', "<leader>ghD", function()
          gitsigns.diffthis '@'
        end, { desc = "[G]it [D]iff against last commit" })

        -- Toggles
        map('n', "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle Git show [b]lame line" })
        map('n', "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle Git show [D]eleted" })
      end,
    },
  },
}
