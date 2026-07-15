-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy',
      },
    }

    -- VS Code's launch.json allows // and /* */ comments (JSONC); nvim-dap's
    -- loader uses plain vim.json.decode, which chokes on them. Strip
    -- comments before decoding, string-boundary-aware so a "//" inside an
    -- actual string value (e.g. a URL) doesn't get mangled.
    require('dap.ext.vscode').json_decode = function(str)
      local out, in_string, i, n = {}, false, 1, #str
      while i <= n do
        local c = str:sub(i, i)
        if in_string then
          out[#out + 1] = c
          if c == '\\' then
            i = i + 1
            out[#out + 1] = str:sub(i, i)
          elseif c == '"' then
            in_string = false
          end
        elseif c == '"' then
          in_string = true
          out[#out + 1] = c
        elseif c == '/' and str:sub(i + 1, i + 1) == '/' then
          local nl = str:find('\n', i)
          i = nl and (nl - 1) or n
        elseif c == '/' and str:sub(i + 1, i + 1) == '*' then
          local close = str:find('*/', i + 2, true)
          i = close and (close + 1) or n
        else
          out[#out + 1] = c
        end
        i = i + 1
      end
      return vim.json.decode(table.concat(out))
    end

    -- nvim-dap's launch.json loader doesn't resolve VS Code's ${workspaceFolder}
    -- (or any other) variable - it inserts the config verbatim. Substitute it
    -- ourselves, recursively, since it can appear nested inside args/env
    -- tables, not just top-level string fields like envFile/cwd.
    local function substitute_workspace_folder(tbl, root)
      for k, v in pairs(tbl) do
        if type(v) == 'string' then
          tbl[k] = v:gsub('%${workspaceFolder}', root)
        elseif type(v) == 'table' then
          substitute_workspace_folder(v, root)
        end
      end
    end

    -- Basic debugging keymaps, feel free to change to your liking!
    -- Re-reads ./.vscode/launch.json (relative to nvim's cwd) on every
    -- press before continuing, so any project with a VS Code debugpy
    -- config - api-nh's "Python Debugger: FastAPI" and friends - shows up
    -- as a pickable configuration with zero project-specific setup here.
    vim.keymap.set('n', '<F5>', function()
      require('dap.ext.vscode').load_launchjs(nil, { debugpy = { 'python' } })
      local root = vim.fn.getcwd()
      for _, configs in pairs(dap.configurations) do
        for _, config in ipairs(configs) do
          substitute_workspace_folder(config, root)
        end
      end
      dap.continue()
    end, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Python debugging via debugpy (installed by mason above). Points at
    -- mason's own copy rather than a per-project .venv, so it works
    -- regardless of which venv is active for the file you're debugging.
    require('dap-python').setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')
  end,
}
