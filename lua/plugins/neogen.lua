return {
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "nvim",
    },
    cmd = "Neogen",
    keys = {
      {
        "<leader>cdf",
        "<cmd>Neogen func<CR>",
        desc = "Generate [C]ode [D]ocumentation: [F]unction",
      },
      {
        "<leader>cdF",
        "<cmd>Neogen file<CR>",
        desc = "Generate [C]ode [D]ocumentation: [F]ile",
      },
      {
        "<leader>cdc",
        "<cmd>Neogen class<CR>",
        desc = "Generate [C]ode [D]ocumentation: [C]lass",
      },
      {
        "<leader>cdt",
        "<cmd>Neogen class<CR>",
        desc = "Generate [C]ode [D]ocumentation: [T]ype",
      },
    }
  },
}
