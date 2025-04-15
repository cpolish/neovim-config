local MAIN_WIN_NUM = 1

--- Delete the "nth" buffer with Snacks "bufdelete".
---
---@param n integer The "nth" buffer to delete.
local function snacks_del_buf(n)
  Snacks.bufdelete.delete(n)
end

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
        close_command = snacks_del_buf,
        left_mouse_command = function(n)
          vim.api.nvim_win_set_buf(vim.fn.win_getid(MAIN_WIN_NUM), n)
        end,
        right_mouse_command = snacks_del_buf,
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
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete Non-Pinned Buffers",
      },
      {
        "<leader>br",
        "<Cmd>BufferLineCloseRight<CR>",
        desc = "Delete Buffers to the Right",
      },
      {
        "<leader>bl",
        "<Cmd>BufferLineCloseLeft<CR>",
        desc = "Delete Buffers to the Left",
      },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      {
        "<leader>ba",
        function() Snacks.bufdelete.all() end,
        desc = "Delete All Buffers",
      },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
  }
}
