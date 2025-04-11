return {
  {
    "rmagatti/auto-session",
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Downloads" },
      ---@diagnostic disable-next-line: assign-type-mismatch
      auto_restore_last_session = (
        (vim.fn.argc(-1) == 0) and (vim.uv.cwd() == vim.uv.os_homedir())
      ),
      session_lens = {
        load_at_startup = false,
      },
      no_restore_cmds = {
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)

          if vim.fn.isdirectory(buf_name) == 1 then
            vim.api.nvim_buf_delete(0, {})
          end
        end,
      },
    },
  },
}
