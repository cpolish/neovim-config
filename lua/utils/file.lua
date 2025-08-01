---Module containing functions relating to interacting with files and the filesystem.
local M = {}

--- Check if the path points to a file which exists, and is a regular file.
---
---@param path string The path to check for regular file existence.
---
---@return boolean `true` if the path points to an existing, regular file, `false`
---otherwise.
function M.file_exists(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

return M
