local LSP_SERVERS = {
  "clangd",
  "pyright",

  "ts_ls",
  "cssls",
  "eslint",
  "html",

  "jdtls",
  "gradle_ls",

  "jsonls",

  "lua_ls",

  "roslyn",
}

return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    "mason-org/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        lazy = true,
        init = function()
          -- Brief aside: **What is LSP?**
          --
          -- LSP is an initialism you've probably heard, but might not understand what it
          -- is.
          --
          -- LSP stands for Language Server Protocol. It's a protocol that helps editors
          -- and language tooling communicate in a standardized fashion.
          --
          -- In general, you have a "server" which is some tool built to understand a
          -- particular language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These
          -- Language Servers (sometimes called LSP servers, but that's kind of like ATM
          -- Machine) are standalone processes that communicate with some "client" - in
          -- this case, Neovim!
          --
          -- LSP provides Neovim with features like:
          --  - Go to definition
          --  - Find references
          --  - Autocompletion
          --  - Symbol Search
          --  - and more!
          --
          -- Thus, Language Servers are external tools that must be installed separately
          -- from Neovim. This is where `mason` and related plugins come into play.
          --
          -- If you're wondering about lsp vs treesitter, you can check out the
          -- wonderfully and elegantly composed help section, `:help lsp-vs-treesitter`

          --  This function gets run when an LSP attaches to a particular buffer.
          --    That is to say, every time a new file is opened that is associated with
          --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`)
          --    this function will be executed to configure the current buffer
          vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
              -- NOTE: Remember that Lua is a real programming language, and as such it is
              -- possible to define small helper and utility functions so you don't have
              -- to repeat yourself.
              --
              -- In this case, we create a function that lets us more easily define
              -- mappings specific for LSP related items. It sets the mode, buffer and
              -- description for us each time.

              ---Map a key binding for the current event buffer.
              ---
              ---@param keys string The key sequence to be associated with this
              ---keybinding.
              ---@param func fun(): nil A function to execute when the keybinding is
              ---triggered.
              ---@param desc string A description of what the keybinding does.
              ---@param mode string|string[]|nil The mode(s) in which the keybinding
              ---should be active in. Defaults to 'n' (normal mode) if not provided.
              local map = function(keys, func, desc, mode)
                mode = mode or 'n'
                vim.keymap.set(mode, keys, func,
                               { buffer = event.buf, desc = "LSP: " .. desc })
              end

              -- Rename the variable under your cursor.
              --  Most Language Servers support renaming across files, etc.
              map("<leader>cr", vim.lsp.buf.rename, "[C]ode: [R]ename Symbol")

              -- Execute a code action, usually your cursor needs to be on top of an error
              -- or a suggestion from your LSP for this to activate.
              map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { 'n', 'x' })

              -- Show diagnostics in floating window when pressing "<leader>ce"
              map("<leader>ce", vim.diagnostic.open_float, "[C]ode: Open Diagnostic")

              -- The following two autocommands are used to highlight references of the
              -- word under your cursor when your cursor rests there for a little while.
              --    See `:help CursorHold` for information about when this is executed
              --
              -- When you move your cursor, the highlights will be cleared (the second
              -- autocommand).
              local doc_highlight_support =
                  vim.lsp.protocol.Methods.textDocument_documentHighlight

              local client = vim.lsp.get_client_by_id(event.data.client_id)
              if client and client:supports_method(doc_highlight_support) then
                local highlight_augroup = vim.api.nvim_create_augroup(
                  "kickstart-lsp-highlight",
                  { clear = false }
                )
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                  buffer = event.buf,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                  buffer = event.buf,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd("LspDetach", {
                  group = vim.api.nvim_create_augroup(
                    "kickstart-lsp-detach",
                    { clear = true }
                  ),
                  callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({
                      group = "kickstart-lsp-highlight",
                      buffer = event2.buf
                    })
                  end,
                })
              end

              -- The following code creates a keymap to toggle inlay hints in your
              -- code, if the language server you are using supports them
              --
              -- This may be unwanted, since they displace some of your code
              local inlay_hints_support = vim.lsp.protocol.Methods.textDocument_inlayHint

              if client and client:supports_method(inlay_hints_support) then
                map("<leader>th", function()
                  vim.lsp.inlay_hint.enable(
                    not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
                  )
                end, "[T]oggle Inlay [H]ints")
              end
            end,
          })

          -- Set settings for diagnostics
          local diagnostic_config = { float = { border = "rounded" } }

          -- Change diagnostic symbols in the sign column (gutter)
          if vim.g.have_nerd_font then
            local diagnostic_signs = {}
            for type, icon in pairs(vim.g.diagnostic_signs) do
              diagnostic_signs[vim.diagnostic.severity[type]] = icon
            end

            diagnostic_config.signs = { text = diagnostic_signs }
          end

          vim.diagnostic.config(diagnostic_config)
        end,
      },

      -- Automatically install LSPs and related tools to stdpath for Neovim
      "mason-org/mason-lspconfig.nvim",
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

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.

      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.list_slice(LSP_SERVERS)
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "prettierd",
      })
      local mason_tool_installer = require("mason-tool-installer")
      mason_tool_installer.setup({ ensure_installed = ensure_installed })

      vim.lsp.enable(LSP_SERVERS)
    end,
  },
}
