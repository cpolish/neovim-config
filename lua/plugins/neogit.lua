local FOLD_ICONS = { '', '' }

return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      {
        "sindrets/diffview.nvim",
        opts = {
          enhanced_diff_hl = true,
        },
      },        -- optional - Diff integration
      "ibhagwan/fzf-lua",              -- optional
    },
    opts = {
      kind = "floating",
      progress_spinner = true,
      commit_editor = {
        kind = "floating",
        show_staged_diff = false,
      },
      commit_select_view = {
        kind = "floating",
      },
      signs = {
        item = FOLD_ICONS,
        section = FOLD_ICONS,
      },
    },
    keys = {
       { "<leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" },
    },
    config = function(_, opts)
      require("neogit").setup(opts)

      -- Setup autocmd so that Neo-tree refreshes after an update
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitStatusRefreshed",
        group = vim.api.nvim_create_augroup("refresh-neotree-on-neogit-update",
                                            { clear = true }),
        callback = function()
          if not package.loaded["neo-tree.events"] then
            return
          end

          local nt_events = require("neo-tree.events")
          nt_events.fire_event(nt_events.GIT_EVENT)
        end,
      })
    end
  },
}
