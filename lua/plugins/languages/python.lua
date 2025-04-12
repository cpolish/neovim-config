return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = { "python", "toml.python" },
    branch = "regexp", -- This is the regexp branch, use this for the new version
    ---@module "venv-selector"
    ---@type venv-selector.Config
    opts = {
      ---@diagnostic disable-next-line: missing-fields
      options = {
        picker = "native",
      }
    },
  },
}
