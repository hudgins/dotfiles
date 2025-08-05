return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "jay-babu/mason-nvim-dap.nvim",
      event = "BufReadPre", -- <-- this
    },
  },
  keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<F6>", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
  },
  -- opts = function()
  --   local dap = require("dap")
    -- vim.fn.sign_define('DapStopped', {text='➡️', texthl='Error', linehl='Search', numhl='Error'})
    -- vim.api.nvim_set_hl(0, 'YellowCursor', { fg='#FFCC00', bg='None' })
    -- vim.api.nvim_set_hl(0, 'YellowBack', { bg="#4C4C19" })
    -- vim.fn.sign_define('DapStopped', { text='', texthl='YellowCursor', linehl='YellowBack', numhl=''})
    -- dap.listeners.after['event_stopped']['my-plugin'] = function(session, body)
    --   vim.cmd('NeovideFocus')
    -- end
    -- dap.configurations.php = {
    --     {
    --         type = "php",
    --         request = "launch",
    --         name = "Listen for Xdebug:9000 - main",
    --         port = 9000,
    --         serverSourceRoot = '/var/www/',
    --         localSourceRoot = '/Users/guru/projects/programs/',
    --     },
    --     {
    --         type = "php",
    --         request = "launch",
    --         name = "Listen for Xdebug:9001",
    --         port = 9001,
    --         serverSourceRoot = '/var/www/',
    --         localSourceRoot = '/Users/guru/projects/programs/',
    --     },
    --     {
    --         type = "php",
    --         request = "launch",
    --         name = "Listen for Xdebug:9003",
    --         port = 9003,
    --         serverSourceRoot = '/var/www/',
    --         localSourceRoot = '/Users/guru/projects/programs/',
    --     }
    -- }
  -- end
}
