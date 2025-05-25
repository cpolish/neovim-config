return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', "<leader>cx", "<cmd>RustLsp explainError<CR>",
                           { buffer = bufnr, desc = "LSP: E[x]plain Rust Error" })
          end,
        },
        tools = {
          float_win_config = { border = "rounded" },
        },
      }
    end
  },
}
