return {
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      terminal = {
        win = { height = 18 },
      },
      styles = {
        ---@diagnostic disable-next-line: missing-fields
        terminal = {
          bo = {
            filetype = "Terminal",
          },
        },
      }
    },
    keys = {
      {
        "<c-`>",
        function() Snacks.terminal.toggle() end,
        desc = "Toggle Terminal",
        mode = {'n', 't'},
      },
    },
  },
}
