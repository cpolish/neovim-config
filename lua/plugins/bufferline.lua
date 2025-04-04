local MAIN_WIN_NUM = 1

return {
  {
    "akinsho/bufferline.nvim",
    version = '*',
    event = "BufEnter",
    -- event = "VeryLazy",
    -- lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        close_command = function(n)
          require("mini.bufremove").delete(n)
        end,
        left_mouse_command = function(n)
          vim.api.nvim_win_set_buf(vim.fn.win_getid(MAIN_WIN_NUM), n)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n)
        end,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "snacks_layout_box",
          },
        },
      },
    },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
  }
}
