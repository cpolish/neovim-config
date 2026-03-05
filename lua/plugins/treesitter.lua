local ENSURE_INSTALLED_PARSERS = {
  "astro",
  "bash",
  "c",
  "c_sharp",
  "css",
  "diff",
  "doxygen",
  "html", "htmldjango",
  "java",
  "javascript", "jsdoc",
  "json", "json5",
  "lua", "luadoc",
  "markdown", "markdown_inline",
  "mermaid",
  "python",
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "typescript", "tsx",
  "vim", "vimdoc",
  "yaml",
}

return {
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    init = function()
      -- Configure auto-installation
      vim.defer_fn(function()
        require("nvim-treesitter").install(ENSURE_INSTALLED_PARSERS)
      end, 1000)

      -- Set up group for tree-sitter autocmds
      local treesitter_augroup = vim.api.nvim_create_augroup("tree-sitter",
                                                             { clear = true })

      -- Highlight
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Highlight filetypes with tree-sitter (when available)",
        group = treesitter_augroup,
        pattern = { "<filetype>" },
        callback = vim.treesitter.start,
      })

      -- Set fold options
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      -- Enable tree-sitter indentation
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable tree-sitter based indentation (when available)",
        group = treesitter_augroup,
        pattern = { "<filetype>" },
        callback = function()
          vim.bo.indentexpr = [[ v:lua.require("nvim-treesitter").indentexpr() ]]
        end,
      })
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
