return {
  -- Java LSP with debugging support
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
  },

  -- Debug Adapter Protocol
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      -- Configure Groovy to use Java debug adapter
      -- This allows debugging Spock tests written in Groovy
      dap.configurations.groovy = dap.configurations.java
    end,
    dependencies = {
      -- UI for debugging
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
        config = function()
          local dap, dapui = require 'dap', require 'dapui'
          dapui.setup {
            layouts = {
              {
                elements = {
                  { id = 'scopes', size = 0.25 },
                  { id = 'breakpoints', size = 0.25 },
                  { id = 'stacks', size = 0.25 },
                  { id = 'watches', size = 0.25 },
                },
                size = 40,
                position = 'left',
              },
              {
                elements = {
                  { id = 'repl', size = 0.5 },
                  { id = 'console', size = 0.5 },
                },
                size = 10,
                position = 'bottom',
              },
            },
          }

          -- Automatically open/close dapui when debugging starts/ends
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
        end,
      },

      -- Virtual text support for debugging
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    keys = {
      -- Debug keybindings
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = '[D]ebug: Toggle [B]reakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = '[D]ebug: [C]ontinue',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = '[D]ebug: Step [I]nto',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = '[D]ebug: Step [O]ver',
      },
      {
        '<leader>dO',
        function()
          require('dap').step_out()
        end,
        desc = '[D]ebug: Step [O]ut',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.open()
        end,
        desc = '[D]ebug: Open [R]EPL',
      },
      {
        '<leader>dl',
        function()
          require('dap').run_last()
        end,
        desc = '[D]ebug: Run [L]ast',
      },
      {
        '<leader>dt',
        function()
          require('dap').terminate()
        end,
        desc = '[D]ebug: [T]erminate',
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = '[D]ebug: Toggle [U]I',
      },
    },
  },
}
