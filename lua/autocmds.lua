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

-- Check if we need to reload buffers in Neovim if a file has changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave"}, {
  desc = "Reload buffers in Neovim if a file has changed",
  group = vim.api.nvim_create_augroup("reload-buf-check", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd([[ checktime ]])
    end
  end,
})
