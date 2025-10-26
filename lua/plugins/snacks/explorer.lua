return {
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {
        replace_netrw = false,
        trash = true,
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
