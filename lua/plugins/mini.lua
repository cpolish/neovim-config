---@alias MiniStatuslineGroup {
---  hl: string,
---  strings: string[],
---}

---@alias DiagnosticCounts {
---  [1]: integer,
---  [2]: integer,
---  [3]: integer,
---  [4]: integer,
---}

---@alias DiagnosticName
---| '"ERROR"'
---| '"WARN"'
---| '"INFO"'
---| '"HINT"'

---@alias DiagnosticHighlightDefinition { [DiagnosticName]: string }

local DIAGNOSTIC_NAMES = { "ERROR", "WARN", "INFO", "HINT" }

---Get the statusline formatting for the filename section of the file.
---
---If the buffer is of a terminal type, it is described appropriately, otherwise, the
---filename (and if required, a read-only modified) is displayed.
---
---@return string filename_statusline_section The string section for the filename of the
---statusline.
local function statusline_section_filename()
  if vim.bo.buftype == "terminal" then
    return "%t"
  end

  local filename_str = "%f"
  if vim.bo.readonly then
    filename_str = filename_str .. " (read-only)"
  end

  return filename_str
end

---Return whether or not diagnostics are disabled for the currently active buffer.
---
---@return boolean diagnostics_active Whether or not diagnostics are not active for the
---current buffer.
local function lsp_diagnostics_disabled()
  return not vim.diagnostic.is_enabled({ bufnr = 0 })
end

---Get the size of the current file, and format it as a string in a nice way.
---
---@return string formatted_file_size A string displaying the file size formatted in a
---nice fashion.
local function get_file_size()
  local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
  if size < 1024 then
    return string.format("%dB", size)
  elseif size < 1048576 then
    return string.format("%.2fKiB", size / 1024)
  else
    return string.format("%.2fMiB", size / 1048576)
  end
end

-- Collection of various small independent plugins/modules
return {
  {
    "nvim-mini/mini.ai",
    version = '*',
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
  },
  {
    "nvim-mini/mini.surround",
    version = '*',
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.statusline",
    version = '*',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local statusline = require("mini.statusline")
      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN

      local use_icons = vim.g.have_nerd_font
      local builtin_diagnostic_hl = {
        ERROR = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }),
        WARN = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }),
        INFO = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }),
        HINT = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }),
      }

      ---@type DiagnosticHighlightDefinition | nil
      local diagnostic_hl_names = nil

      ---Get the highlight names for all LSP diagnostics
      ---
      ---@return DiagnosticHighlightDefinition diagnostic_hl_names The names of the
      ---highlights for all LSP diagnostics.
      local get_diagnostic_hl_names = function()
        if diagnostic_hl_names == nil then
          -- "Lazy" initialise the diagnostic highlight groups
          local statusline_devinfo_hl = vim.api.nvim_get_hl(
            0,
            { name = "MiniStatuslineDevinfo" }
          )

          -- Create the highlight groups
          local diagnostic_hl_names_table = {}

          for _, diagnostic_name in ipairs(DIAGNOSTIC_NAMES) do
            local diagnostic_hl_name = ("StatuslineDiagnostic%s"):format(
              require("utils.string").capitalise(diagnostic_name)
            )

            vim.api.nvim_set_hl(0, diagnostic_hl_name, {
              fg = builtin_diagnostic_hl[diagnostic_name].fg,
              bg = statusline_devinfo_hl.bg,
            })

            diagnostic_hl_names_table[diagnostic_name] = diagnostic_hl_name
          end

          diagnostic_hl_names = diagnostic_hl_names_table
        end

        return diagnostic_hl_names
      end

      ---Get the string for the LSP diagnostic.
      ---
      ---@param diagnostic_counts DiagnosticCounts The diagnostic counts currently active.
      ---@param diagnostic_name DiagnosticName The diagnostic name for the diagnostic
      ---string that is to be constructed.
      ---
      ---@return string diagnostic_string The diagnostic string for the statusline.
      local section_diagnostic_by_name = function(diagnostic_counts, diagnostic_name)
        if statusline.is_truncated(75) then
          return ""
        end

        local count = diagnostic_counts[vim.diagnostic.severity[diagnostic_name]] or 0
        if (count == 0) or lsp_diagnostics_disabled() then
          return ""
        end

        return ("%s %d"):format(vim.g.diagnostic_signs[diagnostic_name], count)
      end

      ---Create a Mini statusline group to represent a given diagnostic section, which
      ---will have its own highlighting applied to it.
      ---
      ---@param diagnostic_counts DiagnosticCounts The diagnostic counts currently active.
      ---@param diagnostic_name DiagnosticName The diagnostic name for the Mini statusline
      ---highlight group that is to be constructed.
      ---
      ---@return MiniStatuslineGroup
      local section_diagnostic_group_by_name = function(
        diagnostic_counts,
        diagnostic_name
      )
        local hl_names = get_diagnostic_hl_names()
        local statusline_string = section_diagnostic_by_name(diagnostic_counts,
                                                             diagnostic_name)

        return { hl = hl_names[diagnostic_name], strings = { statusline_string }}
      end

      ---The below helps simulate "lazy" initialisation for a "get icon" function,
      ---ensuring this function is only called once, and when required.
      ---
      ---@type fun(): string, string
      local get_icon = nil

      ---Ensure that the `get_icon` function is initialised.
      local ensure_get_icon = function()
        if (not use_icons) or (get_icon ~= nil) then
          return
        end

        get_icon = function()
          local devicons = require("nvim-web-devicons")
          return devicons.get_icon(vim.fn.expand("%:t"), nil, { default = true })
        end
      end

      ---Construct a statusline string to represent information about the file in the
      ---current buffer.
      ---
      ---@return string filename_info A statusline string to represent info about the file
      ---in the current buffer.
      local section_fileinfo = function()
        local filetype = vim.bo.filetype

        ensure_get_icon()
        if (get_icon ~= nil) and (filetype ~= "") then
          filetype = ("%s %s"):format(get_icon(), filetype)
        end

        -- Return if the output is truncated, or buffer is not normal
        if statusline.is_truncated(120) or (vim.bo.buftype ~= "") then
          return filetype
        end

        -- Construct output string with extra file info
        local encoding = vim.bo.fileencoding
        local format = vim.bo.fileformat
        local size = get_file_size()

        local output_data = { filetype, encoding, format, size }
        local filtered_output_data = vim.tbl_filter(
          function(value) return value ~= "" end,
          output_data
        )

        -- local filtered_output_data = filtered_output_data_iter:collect()
        return table.concat(filtered_output_data, " | ")
      end

      ---Construct a statusline string to represent information about any macro which may
      ---be currently recorded.
      ---
      ---If not macro is currently being recorded, this function returns an empty string.
      ---
      ---@return string macro_record_info A statusline string to represent info about any
      ---macro which may be currently being recorded, or an empty string if no macro is
      ---being recorded.
      local section_macro_recording = function()
        local macro_record_register = vim.fn.reg_recording()

        if macro_record_register == "" then
          return ""
        end

        return "recording @" .. macro_record_register
      end

      ---Computes the statusline, and returns the formatted Vim statusline string.
      ---
      ---@return string statusline_string The formatted Vim statusline string, after being
      ---computed.
      local compute_statusline = function()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })

        local git = statusline.section_git({ trunc_width = 40 })
        local macro_recording = section_macro_recording()

        local git_macro_recording_sep = ""
        if (git ~= "") and (macro_recording ~= "") then
          git_macro_recording_sep = '|'
        end

        local diagnostic_counts = vim.diagnostic.count(vim.api.nvim_get_current_buf())

        local error_diagnostics = section_diagnostic_group_by_name(diagnostic_counts,
                                                                   "ERROR")
        local warn_diagnostics = section_diagnostic_group_by_name(diagnostic_counts,
                                                                  "WARN")
        local info_diagnostics = section_diagnostic_group_by_name(diagnostic_counts,
                                                                  "INFO")
        local hint_diagnostics = section_diagnostic_group_by_name(diagnostic_counts,
                                                                  "HINT")

        local filename      = statusline_section_filename()
        local fileinfo      = section_fileinfo()
        local location      = "%2l:%-2v"
        local search        = statusline.section_searchcount({ trunc_width = 75 })

        return statusline.combine_groups({
          { hl = mode_hl,                  strings = { mode } },
          {
            hl = "MiniStatuslineDevinfo",
            strings = { git, git_macro_recording_sep, macro_recording }
          },
          error_diagnostics,
          warn_diagnostics,
          info_diagnostics,
          hint_diagnostics,
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl,                  strings = { search, location } },
        })
      end

      -- Set up the plugin here
      statusline.setup({
        content = {
          active = compute_statusline,
        },
        use_icons = vim.g.have_nerd_font,
      })
    end,
  },
}
