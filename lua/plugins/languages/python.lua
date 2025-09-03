return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = { "python", "toml.python" },
    opts = {
      options = {
        picker = "snacks",
      },
    },
  },
}
