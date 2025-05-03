return {
  {
    "Bekaboo/dropbar.nvim",
    event = "BufEnter",
    opts = {
      bar = {
        sources = function(buf)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")

          local buf_opts = vim.bo[buf]

          if buf_opts.ft == "markdown" then
            return { sources.markdown }
          end

          if buf_opts.buftype == "terminal" then
            return { sources.terminal }
          end

          return { utils.source.fallback({ sources.lsp, sources.treesitter }) }
        end,
      },
      icons = {
        ui = {
          bar = {
            separator = "   "
          }
        }
      }
    },
  },
}
