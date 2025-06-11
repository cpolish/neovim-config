return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },
  {
    "nicholasmata/nvim-dap-cs",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
  },
}
