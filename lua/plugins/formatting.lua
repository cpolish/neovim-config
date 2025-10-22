local JS_FORMATTERS_TABLE = { "prettierd", "prettier", stop_after_first = true }

local PRETTIER_CONFIG = {
  require_cwd = true,
}

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "[C]ode: [F]ormat buffer",
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        javascript = JS_FORMATTERS_TABLE,
        javascriptreact = JS_FORMATTERS_TABLE,
        typescript = JS_FORMATTERS_TABLE,
        typescriptreact = JS_FORMATTERS_TABLE,
      },
      format_on_save = { timeout_ms = 500 },
      formatters = {
        prettierd = PRETTIER_CONFIG,
        prettier = PRETTIER_CONFIG,
      },
    },
  },
}
