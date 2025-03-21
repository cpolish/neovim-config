---Module containing utility functions to work with strings.
local M = {}

---Convert a string to "capital case" - that is, with its first character converted to
---uppercase, whilst all other characters are converted to lowercase.
---
---@param value string The input string to convert to "capital case".
---
---@return string capitalised_str The input string converted to "capital case".
function M.capitalise(value)
  local capitalised_str = value:lower():gsub("^%l", string.upper)
  return capitalised_str
end

return M
