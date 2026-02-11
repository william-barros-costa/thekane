return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
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
        dapui.open()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.open()
      end

      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug Test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug Test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      local function add_go_dap_configuration()
        local utils = require("utils")
        table.insert(dap.configurations.go, {
          type = "delve",
          name = "Debug with args",
          request = "launch",
          program = "${file}",
          args = utils.Split(vim.fn.input("args: "), "%S+"),
        })
      end

      vim.keymap.set("n", "<leader>daa", add_go_dap_configuration, {})
    end,
  },
}
