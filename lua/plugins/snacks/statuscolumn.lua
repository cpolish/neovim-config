return {
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      statuscolumn = {
        left = { "sign", "git" },
        right = { "mark", "fold" },
        folds = {
          open = true,
        },
      },
    },
  },
}
