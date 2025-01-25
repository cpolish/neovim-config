return {
  {
    "rmagatti/auto-session",
    opts = {
      suppressed_dirs = { "~/", "~/Downloads" },
      auto_restore_last_session = (
        (vim.fn.argc(-1) == 0) and (vim.uv.cwd() == vim.uv.os_homedir())
      ),
      session_lens = {
        load_at_startup = false,
      },
    },
  },
}
