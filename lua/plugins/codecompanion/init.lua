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
        "nvim-mini/mini.diff",
        event = "VeryLazy",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
      "j-hui/fidget.nvim",
      {
        "ravitemer/mcphub.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
        event = "VeryLazy",
        opts = {
          extensions = {
            mcphub = {
              callback = "mcphub.extensions.codecompanion",
            },
          },
        },
      },
    },
    config = function()
      require("plugins.codecompanion.spinner"):init()

      require("codecompanion").setup({
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
          },
        },
      })

      vim.keymap.set("ca", "Chat", "CodeCompanionChat")
    end,
  },
}
