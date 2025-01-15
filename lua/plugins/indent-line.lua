return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    event = "BufEnter",
    main = 'ibl',
    opts = {
      indent = { char = '▏' }
    },
  },
}
