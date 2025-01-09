---Module which contains functions used to save and load directories in a cache.
local M = {}

---Gets the cache directory of Neovim.
---
---If `vim.fn.stdpath("cache")` returns an array, returns the first directory.
---
---@return string cache_dir The cache directory of Neovim.
local function get_nvim_cache_dir()
  local stdpath_cache = vim.fn.stdpath("cache")
  if type(stdpath_cache) == "string" then
    return stdpath_cache
  else
    return stdpath_cache[0]
  end
end

local CACHE_DIR = get_nvim_cache_dir()
local LAST_DIR_FILE = vim.fs.joinpath(CACHE_DIR, "last_dir")

---Saves the most recent current working directory of Neovim to the directory cache file.
function M.save_last_dir()
  local current_dir = vim.fn.getcwd()
  local file = io.open(LAST_DIR_FILE, 'w')
  if file then
    file:write(current_dir)
    file:close()
  end
end

---Loads the most recent current working directory of Neovim, if Neovim was launched with
---no arguments.
function M.load_last_dir_if_no_args()
  if vim.fn.argc() > 0 then
    return
  end

  local file = io.open(LAST_DIR_FILE, 'r')
  if not file then
    return
  end

  local last_dir = file:read()
  file:close()

  if last_dir and vim.fn.isdirectory(last_dir) then
    vim.api.nvim_set_current_dir(vim.fn.fnameescape(last_dir))
  end
end

return M
