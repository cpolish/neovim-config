return {
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {
        replace_netrw = false,
        trash = true,
      },
      picker = {
        sources = {
          explorer = {
            layout = {
              layout = {
                backdrop = false,
                width = 40,
                min_width = 40,
                height = 0,
                position = "left",
                border = "none",
                box = "vertical",
                { win = "list", border = "top", title = "{flags}", title_pos = "center" },
                { win = "preview", title = "{preview}", height = 0.4, border = "top" },
              },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    }
  }
}
