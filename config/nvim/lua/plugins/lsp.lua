-- vim.api.nvim_create_autocmd({'BufNew', 'BufEnter'}, {
--     pattern = { '*.p8' },
--     callback = function(args)
--         vim.lsp.start({
--             name = 'pico8-ls',
--             cmd = { 'pico8-ls', '--stdio' },
--             root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf)),
--             -- Setup your keybinds in the on_attach function
--             on_attach = on_attach,
--         })
--     end
-- })
local configs = require("lspconfig.configs")
local lsp_fallback = require("config.lsp_fallback")

if not configs.pico8_ls then
  configs.pico8_ls = {
    default_config = {
      cmd = { "pico8-ls", "--stdio" },
      filetypes = { "pico8", "p8" },
      root_dir = function(fname) return vim.fs.dirname(fname) end,
      settings = {},
    },
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "gd", false },
            { "gd", function() lsp_fallback.goto_definition_or_grep() end, desc = "Goto Definition", has = "definition" },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                exclude = {
                  "html/wp-content/plugins/**",
                },
                maxSize = 500000,
              },
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pico8_ls = {},  -- enable it
      },
      setup = {
        pico8_ls = function(_, opts)
          require("lspconfig").pico8_ls.setup(opts)
          return true
        end,
      },
    },
  }
}
