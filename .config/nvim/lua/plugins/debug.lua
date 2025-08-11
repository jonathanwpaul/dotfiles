local js_based_languages = {
  'typescript',
  'javascript',
  'typescriptreact',
  'javascriptreact',
  'vue',
}

return {
  { 'nvim-neotest/nvim-nio' },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dapui = require 'dapui'
      local dap = require 'dap'

      dap.defaults.fallback.exception_breakpoints = { 'uncaught' }

      dapui.setup {
        controls = {
          element = 'repl',
          enabled = true,
          icons = {
            disconnect = '',
            pause = '',
            play = '',
            run_last = '',
            step_back = '',
            step_into = '',
            step_out = '',
            step_over = '',
            terminate = '',
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = 'rounded',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        force_buffers = true,
        icons = {
          collapsed = '',
          current_frame = '',
          expanded = '',
        },
        layouts = {
          {
            elements = {
              {
                id = 'scopes',
                size = 0.25,
              },
              {
                id = 'breakpoints',
                size = 0.25,
              },
              {
                id = 'stacks',
                size = 0.25,
              },
              {
                id = 'watches',
                size = 0.25,
              },
            },
            position = 'right',
            size = 50,
          },
          {
            elements = {
              {
                id = 'repl',
                size = 0.5,
              },
              {
                id = 'console',
                size = 0.5,
              },
            },
            position = 'bottom',
            size = 10,
          },
        },
        mappings = {
          edit = 'e',
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          repl = 'r',
          toggle = 't',
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
      }

      for _, adapterType in ipairs { 'node', 'chrome', 'msedge' } do
        local pwaType = 'pwa-' .. adapterType

        dap.adapters[pwaType] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            args = {
              vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
              '${port}',
            },
          },
        }

        -- this allow us to handle launch.json configurations
        -- which specify type as "node" or "chrome" or "msedge"
        dap.adapters[adapterType] = function(cb, config)
          local nativeAdapter = dap.adapters[pwaType]

          config.type = pwaType

          if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      -- local Config = require 'lazyvim.config'
      -- vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
      --
      -- for name, sign in pairs(Config.icons.dap) do
      --   sign = type(sign) == 'table' and sign or { sign }
      --   vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
      -- end

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {

            type = 'pwa-chrome',
            request = 'attach',
            name = 'Attach to Chrome',
            port = 9222,
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = 'Enter URL: ',
                  default = 'http://localhost:3000',
                }, function(url)
                  if url == nil or url == '' then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
          },
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch & Debug Chrome',
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = 'Enter URL: ',
                  default = 'http://localhost:3000',
                }, function(url)
                  if url == nil or url == '' then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            runtimeArgs = {
              '--remote-debugging-port=9222',
            },
            userDataDir = vim.fn.stdpath 'data' .. '/dap-chrome-profile', -- we already set our own in runtimeArgs
            timeout = 20000,
          },
          {
            type = 'pwa-msedge',
            request = 'launch',
            name = 'Launch & Debug Edge',
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = 'Enter URL: ',
                  default = 'http://localhost:3000',
                }, function(url)
                  if url == nil or url == '' then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
          },
          -- Divider for the launch.json derived configs
          {
            name = '----- ↓ launch.json configs ↓ -----',
            type = '',
            request = 'launch',
          },
        }
      end

      -- Set keymaps to control the debugger
      vim.keymap.set('n', '<F5>', require('dap').continue)
      vim.keymap.set('n', '<F10>', require('dap').step_over)
      vim.keymap.set('n', '<F11>', require('dap').step_into)
      vim.keymap.set('n', '<F12>', require('dap').step_out)
      vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint)
      vim.keymap.set('n', '<leader>B', function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end)

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close {}
      end

      vim.keymap.set('n', '<F7>', require('dapui').toggle)
    end,
    keys = {
      {
        '<leader>da',
        function()
          if vim.fn.filereadable '.vscode/launch.json' then
            local dap_vscode = require 'dap.ext.vscode'
            dap_vscode.load_launchjs(nil, {
              ['pwa-node'] = js_based_languages,
              ['chrome'] = js_based_languages,
              ['pwa-chrome'] = js_based_languages,
            })
          end
          require('dap').continue()
        end,
        desc = 'Run with Args',
      },
    },
    dependencies = {
      'rcarriga/nvim-dap-ui',
      -- Install the vscode-js-debug adapter
      {
        'microsoft/vscode-js-debug',
        -- After install, build it and rename the dist directory to out
        build = 'npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && mv dist out',
        version = '1.*',
      },
      -- {
      --   'mxsdev/nvim-dap-vscode-js',
      --   config = function()
      --     ---@diagnostic disable-next-line: missing-fields
      --     require('dap-vscode-js').setup {
      --       -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      --       -- node_path = "node",
      --
      --       -- Path to vscode-js-debug installation.
      --       debugger_path = vim.fn.resolve(vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug'),
      --
      --       -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
      --       -- debugger_cmd = { "js-debug-adapter" },
      --
      --       -- which adapters to register in nvim-dap
      --       adapters = {
      --         'chrome',
      --         'pwa-node',
      --         'pwa-chrome',
      --         'pwa-msedge',
      --         'pwa-extensionHost',
      --         'node-terminal',
      --       },
      --       port = 9222,
      --
      --       -- Path for file logging
      --       -- log_file_path = '(stdpath cache)/dap_vscode_js.log',
      --
      --       -- Logging level for output to file. Set to false to disable logging.
      --       log_file_level = vim.log.levels.DEBUG,
      --
      --       -- Logging level for output to console. Set to false to disable console output.
      --       -- log_console_level = vim.log.levels.ERROR,
      --       log_console_level = vim.log.levels.DEBUG,
      --     }
      --   end,
      -- },
      {
        'Joakker/lua-json5',
        build = './install.ps1',
      },
    },
  },
}
