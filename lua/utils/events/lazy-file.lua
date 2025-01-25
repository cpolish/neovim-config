local M = {}

local LAZY_FILE_EVENTS = { "BufReadPost", "BufNewFile", "BufWritePre" }

local use_lazy_file = true

-- Properly load file based plugins without blocking the UI
function M.setup()
  use_lazy_file = use_lazy_file and vim.fn.argc(-1) > 0

  -- Add support for the LazyFile event
  local lazy_file_event = require("lazy.core.handler.event")

  if use_lazy_file then
    -- We'll handle delayed execution of events ourselves
    lazy_file_event.mappings.LazyFile = { id = "LazyFile", event = "User",
                                          pattern = "LazyFile" }
    lazy_file_event.mappings["User LazyFile"] = lazy_file_event.mappings.LazyFile
  else
    -- Don't delay execution of LazyFile events, but let lazy know about the mapping
    lazy_file_event.mappings.LazyFile = { id = "LazyFile", event = LAZY_FILE_EVENTS }
    lazy_file_event.mappings["User LazyFile"] = lazy_file_event.mappings.LazyFile
    return
  end

  local events = {}

  local done = false

  local load = function()
    if #events == 0 or done then
      return
    end
    done = true
    vim.api.nvim_del_augroup_by_name("lazy_file")

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      local augroups = lazy_file_event.get_augroups(event.event)
      local groups = vim.tbl_filter(function(t)
        return not vim.tbl_contains({ t }, "filetypedetect")
      end, augroups)
      skips[event.event] = skips[event.event] or groups
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      if vim.api.nvim_buf_is_valid(event.buf) then
        lazy_file_event.trigger({
          event = event.event,
          exclude = skips[event.event],
          data = event.data,
          buf = event.buf,
        })
        if vim.bo[event.buf].filetype then
          lazy_file_event.trigger({
            event = "FileType",
            buf = event.buf,
          })
        end
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
    events = {}
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd(LAZY_FILE_EVENTS, {
    group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end

return M
