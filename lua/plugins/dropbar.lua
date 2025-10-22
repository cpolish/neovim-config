return {
  {
    "Bekaboo/dropbar.nvim",
    event = "BufEnter",
    opts = {
      bar = {
        sources = function(buf)
          local buf_opts = vim.bo[buf]

          if buf_opts.ft == "markdown" then
            return { require("dropbar.sources").markdown }
          end

          if buf_opts.buftype == "terminal" then
            return { require("dropbar.sources").terminal }
          end

          return {
            require("dropbar.utils").source.fallback({
              require("dropbar.sources").lsp,
              require("dropbar.sources").treesitter,
            }),
          }
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
