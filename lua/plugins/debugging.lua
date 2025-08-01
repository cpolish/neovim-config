local file_utils = require("utils.file")

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "GustavEikaas/easy-dotnet.nvim" },
    event = "VeryLazy",
    config = function()
      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp

      -- Setup config for .NET languages (more complex)
      local dotnet = require("easy-dotnet")

      ---@alias DotnetDll {
      ---  project_name: string,
      ---  project_path: string,
      ---  absolute_project_path: string,
      ---  target_path: string,
      ---}

      ---@type DotnetDll|nil
      local dotnet_debug_dll = nil

      ---Obtain the current DLL used for debuggind in .NET.
      ---
      ---@return DotnetDll debug_dll The current DLL used for debugging.
      local get_dotnet_debug_dll = function()
        if dotnet_debug_dll ~= nil then
          return dotnet_debug_dll
        end

        dotnet_debug_dll = dotnet.get_debug_dll()
        return dotnet_debug_dll
      end

      ---Rebuild the .NET target that will be used for debugging.
      ---
      ---@param co thread A coroutine object.
      ---@param path string A path to the project which should be built for debugging.
      local dotnet_rebuild_project = function(co, path)
        local spinner = require("easy-dotnet.ui-modules.spinner").new()
        spinner:start_spinner("Building")

        vim.fn.jobstart(("dotnet build %s"):format(path), {
          on_exit = function(_, return_code)
            if return_code == 0 then
              spinner:stop_spinner("Built successfully")
            else
              spinner:stop_spinner("Build failed with exit code " .. return_code,
                                   vim.log.levels.ERROR)
              error("Build failed")
            end

            coroutine.resume(co)
          end,
        })

        coroutine.yield()
      end

      local dotnet_configs = { "cs", "fsharp" }

      for _, value in ipairs(dotnet_configs) do
        dap.configurations[value] = {
          {
            type = "coreclr",
            name = "Program",
            request = "launch",
            env = function()
              local dll = get_dotnet_debug_dll()
              local vars = dotnet.get_environment_variables(dll.project_name,
                                                            dll.absolute_project_path,
                                                            false)
              return vars or nil
            end,
            program = function()
              local dll = get_dotnet_debug_dll()
              local co = coroutine.running()

              dotnet_rebuild_project(co, dll.project_path)

              if not file_utils.file_exists(dll.target_path) then
                error(("Project has not been built (path: %s)"):format(dll.target_path))
              end

              return dll.target_path
            end,
            cwd = function()
              local dll = get_dotnet_debug_dll()
              return dll.absolute_project_path
            end,
          },
        }
      end

      dap.listeners.before.event_terminated["easy-dotnet"] = function()
        dotnet_debug_dll = nil
      end

      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }
    end,
    keys = {
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Debugger: Toggle Breakpoint",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
