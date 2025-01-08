-- Set <space> as leader key (done before plugins are loaded)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd font setup
vim.g.have_nerd_font = true

-- General Neovim options
require("options")

-- Handle providers for languages in Neovim
require("providers")

-- Basic keymaps
require("keymaps")

-- Bootstrap/install `lazy.nvim` package manager, and onfigure and install plugins
require("lazy-setup")
