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
    },
    keys = {
       { "<leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" },
    },
  },
}
