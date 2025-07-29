require("fzf-lua").setup({
  -- files = {
  --   formatter = "path.dirname_first", -- places file name first
  -- },
  -- buffers = {
  --   formatter = "path.dirname_first", -- places file name first
  -- },
  -- git_files = {
  --   formatter = "path.dirname_first", -- places file name first
  -- },
  winopts = {
    preview = {
      flip_columns = 180
    }
  }
})

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
    keys = {
      { mode = { "n" }, "<leader>z", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it rain!" },
    }
  },
  {
    "nanotee/zoxide.vim",
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "https://git.sr.ht/~foosoft/argonaut.nvim",
    keys = {
      { mode = { "n" }, "<leader>a", "<cmd>ArgonautToggle<CR>", desc = "Toggle argument wrapping" },
-- vim.keymap.set('n', '<leader>a', ':<c-u>ArgonautToggle<cr>', {noremap = true, silent = true})
-- vim.keymap.set({'x', 'o'}, 'ia', ':<c-u>ArgonautObject inner<cr>', {noremap = true, silent = true})
-- vim.keymap.set({'x', 'o'}, 'aa', ':<c-u>ArgonautObject outer<cr>', {noremap = true, silent = true})
-- vim.keymap.set({'x', 'o', 'n'}, '<leader>n', ':<c-u>ArgonautObject inner<cr>', {noremap = true, silent = true})
-- vim.keymap.set({'x', 'o', 'n'}, '<leader>p', ':<c-u>ArgonautObject outer<cr>', {noremap = true, silent = true})
    },
    opts = {
      brace_last_indent = false,
      brace_last_wrap = true,
      brace_pad = false,
      comma_last = true,
      comma_prefix = false,
      comma_prefix_indent = false,
      limit_cols = 512,
      limit_rows = 64,
      by_filetype = {
          php = {comma_last = true},
      },
    }
  },
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        min_keyword_length = 5,
      }
    },
  },
  {
    "echasnovski/mini.pairs",
    opts = {
      modes = { insert = true, command = false, terminal = false },
    },
  },
  {
    "bakudankun/pico-8.vim",
  },
}
