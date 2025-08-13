return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    ---@module "copilot"
    ---@type CopilotConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ---@diagnostic disable-next-line: missing-fields
      suggestion = {
        suggestion = { enabled = false },
        panel = { enabled = false },
      },
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
    },
  },
}
