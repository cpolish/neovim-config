return {
  {
    "luukvbaal/statuscol.nvim",
    event = "BufEnter",
    config = function()
      local builtin = require("statuscol.builtin")

      require("statuscol").setup({
        relculright = true,
        segments = {
          { sign = { namespace = { "gitsigns" }, colwidth = 1 } },
          { sign = { namespace = { ".*" } } },
          { text = { builtin.lnumfunc, ' ' }, click = "v:lua.ScLa" },
          { text = { builtin.foldfunc, ' ' }, click = "v:lua.ScFa" },
        },
      })
    end,
  }
}
