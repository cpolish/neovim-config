-- Set custom filetypes
vim.filetype.add({
  extension = {
    cshtml = "razor",
    razor = "razor",
  },
  filename = {
    ["pyproject.toml"] = "toml.pyproject",
  },
})
