-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Tab closing
vim.keymap.set('n', "<leader>td", "<cmd>tabclose<CR>", { desc = "Delete tab" })

-- Set macro record key to '\' to avoid accidentally pressing it
vim.keymap.set('n', '\\', 'q')
vim.keymap.set('n', 'q', "<Nop>")

if vim.g.neovide then
  local paste_modes = { 'n', 'v', 's', 'x', 'o', 'i', 'l', 'c', 't' }
  local paste_fn = function() vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end
  local paste_keymap_opts = { noremap = true, silent = true }

  local paste_keymap = (vim.uv.os_uname().sysname == "Darwin") and "<D-v>" or "<C-S-v>"

  vim.keymap.set(paste_modes, paste_keymap, paste_fn, paste_keymap_opts)
end
