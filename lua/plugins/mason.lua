local LSP_SERVERS = {
  "clangd",
  "pyright",

  "ts_ls",
  "cssls",
  "eslint",
  "html",
  "astro",
  "tailwindcss",

  "jdtls",
  "gradle_ls",

  "jsonls",

  "lua_ls",

  "roslyn",
  "rzls",

  -- Extra LSPs where the mapping between lspconfig and Mason isn't well defined
  "djlsp",
}

return {
  {
    -- Main LSP Configuration
    "mason-org/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "neovim/nvim-lspconfig",

      -- Automatically install LSPs and related tools to stdpath for Neovim
      "mason-org/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require("fidget").setup({})`
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        }
      })
      require("mason-nvim-dap").setup()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.

      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.list_slice(LSP_SERVERS, 0, #LSP_SERVERS - 2)
      vim.list_extend(ensure_installed, {
        -- Formatters
        "stylua", -- Used to format Lua code
        "prettierd",

        -- Debuggers
        "codelldb",

        -- Extra LSPs we wish to install, but will configure somewhere else
        "django-template-lsp",
      })
      local mason_tool_installer = require("mason-tool-installer")
      mason_tool_installer.setup({ ensure_installed = ensure_installed })

      vim.lsp.enable(LSP_SERVERS)
    end,
  },
}
