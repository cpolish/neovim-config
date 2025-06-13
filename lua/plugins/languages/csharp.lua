return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      -- By loading as a dependencies, we ensure that we are available to set the
      -- handlers for Roslyn.
      { "tris203/rzls.nvim", config = true },
    },
    config = function()
      local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
      local roslyn_cmd = {
        "roslyn",
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        "--extension",
        vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
      }

      vim.lsp.config("roslyn", {
        cmd = roslyn_cmd,
        handlers = require("rzls.roslyn_handlers"),
      })

      require("roslyn").setup()
    end,
  },
  {
    "nicholasmata/nvim-dap-cs",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
}
