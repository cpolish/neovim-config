return {
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {
        replace_netrw = false,
      },
      -- picker = {
      --   sources = {
      --     explorer = {
      --       layout = {
      --         auto_hide = { "input" },
      --       },
      --     },
      --   },
      -- },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    }
  }
}
