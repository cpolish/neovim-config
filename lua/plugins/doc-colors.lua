local CSS_COLOR_OPTS = {
  names = true,
  RGB = true,
  RGBA = true,
  RRGGBB = true,
  RRGGBBAA = true,
  AARRGGBB = true,
  rgb_fn = true,
  hsl_fn = true,
  oklch_fn = true,
  suppress_deprecation = true,
}

return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
      filetypes = {
        css = CSS_COLOR_OPTS,
        scss = CSS_COLOR_OPTS,
        sass = CSS_COLOR_OPTS,
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "htmldjango",
        "razor",
      },
      user_default_options = {
        names = false,
        RGB = false,
        RGBA = false,
        RRGGBB = false,
        tailwind = "lsp",
        mode = "virtualtext",
        virtualtext_inline = "before",
        suppress_deprecation = true,
      },
    },
  },
}
