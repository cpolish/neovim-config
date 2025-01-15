-- Collection of various small independent plugins/modules
return {
  {
    "echasnovski/mini.ai",
    version = '*',
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
  },
  {
    "echasnovski/mini.surround",
    version = '*',
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.statusline",
    version = '*',
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    "echasnovski/mini.bufremove",
    version = '*',
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete()
        end,
        desc = "Delete Buffer",
      },
    },
  },
}
