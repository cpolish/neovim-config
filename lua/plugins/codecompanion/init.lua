return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "codecompanion" },
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons"
        },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
      },
      {
        "echasnovski/mini.diff",
        event = "VeryLazy",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
      -- {
      --   "OXY2DEV/markview.nvim",
      --   lazy = false,
      --   opts = {
      --     preview = {
      --       filetypes = { "markdown", "codecompanion" },
      --       ignore_buftypes = {},
      --     },
      --   }
      -- },
      "j-hui/fidget.nvim",
    },
    opts = {

    },
    config = function()
      require("plugins.codecompanion.spinner"):init()

      require("codecompanion").setup()

      vim.keymap.set("ca", "Chat", "CodeCompanionChat")
    end,
  },
}
