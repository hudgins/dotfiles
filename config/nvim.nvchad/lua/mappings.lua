require "nvchad.mappings"
---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<leader>a"] = "",
    ["<leader>b"] = "",
    ["<leader>e"] = "",
    ["<leader>k"] = "",
    ["<leader>ff"] = "",
    ["<leader>fb"] = "",
    ["<leader>fw"] = "",
    ["<leader>fo"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["gV"] = { "`[v`]", "Visually select the most recently edited/pasted text." },
    ["<leader><space>"] = { "<cmd> update <CR>", "Save file" },
    ["<leader>b"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>h"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>j"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>o"] = { "<cmd> Telescope oldfiles <CR>", "Find recent files" },
    ["<leader>y"] = { '"+y', "Yank to system clipboard" },
    ["<leader>p"] = { '"+p', "Paste (after) from system clipboard" },
    ["<leader>P"] = { '"+P', "Paste (before) from system clipboard" },
    ["<D-v>"]     = { '"+p', "Paste (after) from system clipboard" },
    ["<leader>e"] = {
      -- "<cmd> NvimTreeFindFileToggle! <CR>",
      function()
        local api = require "nvim-tree.api"
        -- api.tree.open { find_file = true, update_root = true }
        api.tree.toggle({ find_file = true, update_root = true, focus = true, })
        -- api.tree.find_file({ update_root = true, open = true, focus = true, })
        -- api.tree.find_file({ update_root = true, open = true, focus = true, })
        -- api.tree.find_file()
      end,
      "Toggle nvimtree",
    },
    ["<leader>tt"] = {
      function()
        require("base46").toggle_theme()
      end,
      "Toggle theme light/dark",
    },
    ["<leader>td"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "Toggle transparency",
    },
    -- ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
    ["<C-d>"] = { "<cmd> vnew <CR>", "Split pane vertical" },
    ["<C-S-d>"] = { "<cmd> new <CR>", "Split pane horizontal" },
    ["<C-S-L>"] = { "<cmd> vertical resize +5 <CR>", "Increase window height" },
    ["<C-S-H>"] = { "<cmd> vertical resize -5 <CR>", "Decrease window height" },
    ["<C-S-K>"] = { "<cmd> horizontal resize +5 <CR>", "Increase window width" },
    ["<C-S-J>"] = { "<cmd> horizontal resize -5 <CR>", "Decrease window width" },
  },
  v = {
    [">"] = { ">gv", "indent" },
    ["<leader>y"] = { '"+y', "Yank to system clipboard" },
    ["<D-c>"] =     { '"+y', "Yank to system clipboard" },
  },
  i = {
    ["<D-v>"]     = { '<ESC>"+p', "Paste (after) from system clipboard" },
  }
}

M.lspconfig = {
  n = {
    ["<C-e>"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Goto next error",
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at current line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Run or continue the debugger",
    },
    ["<F5>"] = {
      "<cmd> DapContinue <CR>",
      "Run or continue the debugger",
    },
    ["<F6>"] = {
      "<cmd> DapToggleRepl <CR>",
      "Show/hide the debug REPL",
    },
    ["<F7>"] = {
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end,
      "Explore stack",
    },
    ["<F8>"] = {
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end,
      "Explore variables",
    },
    ["<F10>"] = {
      "<cmd> DapStepOver <CR>",
      "Step over",
    },
    ["<F11>"] = {
      "<cmd> DapStepInto <CR>",
      "Step into",
    },
    ["<F12>"] = {
      "<cmd> DapStepOut <CR>",
      "Step out",
    },
  },
}
-- vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
-- vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
-- vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
-- vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
-- vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
-- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
-- vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
-- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
-- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
-- vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
--   require('dap.ui.widgets').hover()
-- end)
-- vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
--   require('dap.ui.widgets').preview()
-- end)
-- vim.keymap.set('n', '<Leader>df', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set('n', '<Leader>ds', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.scopes)
-- end)

M.spread = {
  n = {
    ["<leader>a"] = {
      function()
        require("spread").out()
      end,
      "Spread arguments, objects, etc.",
    },
    ["<leader>k"] = {
      function()
        require("spread").combine()
      end,
      "Combine arguments, objects, etc.",
    },
  },
}

M.gitsigns = {
  n = {
    ["<leader>gbt"] = {
      function()
        package.loaded.gitsigns.toggle_current_line_blame()
      end,
      "Toggle current blame line",
    },
  }
}

M.ezguifont = {
  n = {
    ["<C-=>"] = {
      "<cmd> IncreaseFont <CR>",
      "Increase font size",
    },
    ["<C-+>"] = {
      "<cmd> IncreaseFont <CR>",
      "Increase font size",
    },
    ["<C-->"] = {
      "<cmd> DecreaseFont <CR>",
      "Decrease font size",
    },
  }
}

return M
