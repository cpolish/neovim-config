return {
  {
    "akinsho/toggleterm.nvim",
    version = '*',
    opts = {
      size = 20,
      open_mapping = "<c-`>",
    },
    keys = {
      { "<c-`>", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" }
    }
  },
}
