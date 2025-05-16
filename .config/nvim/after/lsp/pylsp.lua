return {
  settings = {
    ["pylsp"] = {
      configurationSources = { "flake8" },
      plugins = {
        flake8 = {
          enabled = true,
          maxLineLength = 120,
          extendIgnore = { "E203" },
        },
        pycodestyle = {
          enabled = false,
        },
        mccabe = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
        yapf = {
          enabled = false,
        },
        autopep8 = {
          enabled = false,
        },
        pylsp_mypy = {
          enabled = true,
        },
        ruff = {
          enabled = false,
          -- extendSelect = { "I" },
        },
      },
    },
  },
}
