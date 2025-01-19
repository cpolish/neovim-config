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
  },
}
