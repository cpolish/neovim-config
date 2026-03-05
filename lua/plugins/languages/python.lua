---@diagnostic disable: missing-fields

return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = { "python", "toml.python" },
    ---@module "venv-selector.config"
    ---@type venv-selector.Settings
    opts = {
      options = {
        override_notify = false,
        picker = "snacks",
      },
    },
  },
}
