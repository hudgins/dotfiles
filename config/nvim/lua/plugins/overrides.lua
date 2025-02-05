return {
  {
    "ellisonleao/gruvbox.nvim",
    opts = function()
      local Gruvbox = require('gruvbox')
      return {
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = false,
        italic = {
          strings = false,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {
          Constant = { italic = true },
          Boolean = { fg = Gruvbox.palette.bright_purple, italic = true },
        },
        dim_inactive = false,
        transparent_mode = true,
      }
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      scroll = { enabled = false },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "phpcs",
        "php-cs-fixer",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.phpcsfixer)
      table.remove(opts.sources, nls.builtins.diagnostics.phpcs)
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    enabled = false,
    opts = {
      linters_by_ft = {
        -- php = { "phpcs" },
      },
    },
  },
  {
    "eandrju/cellular-automaton.nvim",
  },
}
