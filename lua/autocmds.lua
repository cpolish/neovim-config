-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-load directory commands
local auto_dir_group = vim.api.nvim_create_augroup("auto-restore-dirs", { clear = true })
local dir_caching = require("utils.cache-dirs")

-- Save directory when exiting Neovim
vim.api.nvim_create_autocmd("VimLeave", {
  desc = "Saves the current working directory when quitting Neovim",
  group = auto_dir_group,
  callback = dir_caching.save_last_dir,
})

-- Load last directory when starting Neovim, if no arguments were provided
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Restores the last working directory when Neovim is run with no arguments",
  group = auto_dir_group,
  callback = dir_caching.load_last_dir_if_no_args,
})
