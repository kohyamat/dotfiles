return {
  "mfussenegger/nvim-dap",
  config = function()
    -- mason-nvim-dap
    require("mason-nvim-dap").setup({
      ensure_installed = {},
      handlers = {},
    })

    local dap = require("dap")

    -- keymaps
    vim.api.nvim_set_keymap("n", "<F5>", ":DapContinue<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<F10>", ":DapStepOver<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<F11>", ":DapStepInto<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<F12>", ":DapStepOut<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>b", ":DapToggleBreakpoint<CR>", { silent = true })

    -- setup dapui
    local dapui = require("dapui")
    dapui.setup({
      icons = { expanded = "", collapsed = "" },
      layouts = {
        {
          elements = {
            { id = "repl", size = 0.15 },
            { id = "stacks", size = 0.2 },
            { id = "watches", size = 0.2 },
            { id = "scopes", size = 0.35 },
            { id = "breakpoints", size = 0.1 },
          },
          size = 0.4,
          position = "left",
        },

        {
          elements = { "console" },
          size = 0.25,
          position = "bottom",
        },
      },
    })

    vim.api.nvim_set_keymap("n", "<leader>d", ':lua require("dapui").toggle()<CR>', {})
    vim.api.nvim_set_keymap("n", "<leader>de", ':lua require("dapui").eval()<CR>', {})

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end

    -- setup c++/c/rust debugging with codelldb
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        -- CHANGE THIS to your path!
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
        -- On windows you may have to uncomment this:
        -- detached = false,
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- setup python debugging with debugpy
    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
          type = "server",
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          host = host,
          options = {
            source_filetype = "python",
          },
        })
      else
        cb({
          type = "executable",
          command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
          args = { "-m", "debugpy.adapter" },
          options = {
            source_filetype = "python",
          },
        })
      end
    end
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
          -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
          -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            return cwd .. "/venv/bin/python"
          elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            return cwd .. "/.venv/bin/python"
          else
            return vim.g.python3_host_prog
          end
        end,
        console = "integratedTerminal",
      },
    }
  end,
  dependencies = {
    "williamboman/mason.nvim",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
  },
}
