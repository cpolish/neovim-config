return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      { "tpope/vim-fugitive" },
    },
    opts = {
      keymaps = {
        file_panel = {
          {
            "n", "cc",
            "<cmd>Git commit <bar> wincmd J<CR>",
            { desc = "Commit staged changes" },
          },
          {
            "n", "ca",
            "<cmd>Git commit --amend <bar> wincmd J<CR>",
            { desc = "Amend the last commit" },
          },
          {
            "n", "c<space>",
            "<cmd>Git commit ",
            { desc = "Populate command line with \":Git commit \"" },
          },
          {
            "n", "p",
            "<cmd>Git pull<CR>",
            { desc = "Pull changes on current branch" },
          },
          {
            "n", "P",
            "<cmd>Git push<CR>",
            { desc = "Push changes on current branch to remote" },
          },
        },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open [G]it [d]iff view" },
    },
  },
}
