-- Table of providers, depending on the OS that was selected
local host_progs = {
  Windows_NT = {
    python3 = "C:/Program Files/Python313/python.exe",
    node = "C:/Program Files/nodejs/node_modules/neovim/bin/cli.js",
  },
  Darwin = {
    python3 = "/opt/homebrew/bin/python3",
    node = "/Users/chris/Library/Node/bin/neovim-node-host",
  },
}

local os_name = vim.uv.os_uname().sysname
local os_specific_config = host_progs[os_name]

if os_specific_config ~= nil then
  vim.g.python3_host_prog = os_specific_config.python3
  vim.g.node_host_prog = os_specific_config.node
else
  vim.g.python3_host_prog = "/usr/bin/python3"

  -- Check if NVM is used - if so, set the path accordingly
  local nvm_base_path = vim.env.HOME .. "/.nvm"
  if vim.fn.isdirectory(nvm_base_path) then
    vim.g.node_host_prog = nvm_base_path .. "/versions/node/v22.11.0/bin/neovim-node-host"
  else
    vim.g.node_host_prog = "/usr/bin/neovim-node-host"
  end
end
