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
              stubs = {
                "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype",
                "curl", "date", "dba", "dom", "enchant", "exif", "FFI", "fileinfo",
                "filter", "fpm", "ftp", "gd", "gettext", "gmp", "hash", "iconv",
                "imap", "intl", "json", "ldap", "libxml", "mbstring", "meta", "mysqli",
                "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_ibm",
                "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix",
                "pspell", "readline", "Reflection", "session", "shmop", "SimpleXML",
                "snmp", "soap", "sockets", "sodium", "SPL", "sqlite3", "standard",
                "superglobals", "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer",
                "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache",
                "zip", "zlib",
                -- added:
                "redis",
              },
              diagnostics = {
                undefinedConstants = false,
                unusedSymbols = false,
              },
              environment = {
                phpVersion = 8.4
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
