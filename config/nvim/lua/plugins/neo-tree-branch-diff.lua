return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    {
      "<leader>gd",
      function()
        vim.cmd("Neotree toggle source=branch_diff")
      end,
      desc = "Git Branch Diff (Neo-tree)",
    },
  },

  config = function(_, opts)
    opts.sources = opts.sources or {}
    local has_source = false
    for _, source in ipairs(opts.sources) do
      if source == "branch_diff" then
        has_source = true
        break
      end
    end
    if not has_source then
      table.insert(opts.sources, "branch_diff")
    end

    opts.branch_diff = opts.branch_diff or {}
    if opts.branch_diff.use_default_mappings == nil then
      opts.branch_diff.use_default_mappings = false
    end

    opts.branch_diff.renderers = opts.branch_diff.renderers or {
      root = {
        { "indent" },
        { "icon", default = "" },
        { "name" },
      },
      directory = {
        { "indent" },
        { "icon" },
        { "name", use_git_status_colors = true },
      },
      file = {
        { "indent" },
        { "icon" },
        {
          "container",
          content = {
            { "name", use_git_status_colors = true, zindex = 10 },
            { "git_status", zindex = 20, align = "right" },
          },
        },
      },
      message = {
        { "indent", with_markers = false },
        { "name", highlight = "NeoTreeMessage" },
      },
    }

    opts.branch_diff.window = opts.branch_diff.window or {}
    opts.branch_diff.window.mappings = opts.branch_diff.window.mappings or {
      ["<cr>"] = "open",
      ["o"] = "open",
      ["l"] = "open",
      ["<2-LeftMouse>"] = "open",
      ["<space>"] = "toggle_node",
      ["h"] = "close_node",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["R"] = "refresh",
      ["r"] = "refresh",
      ["q"] = "close_window",
      ["<esc>"] = "revert_preview",
    }

    opts.source_selector = opts.source_selector or {}
    opts.source_selector.sources = opts.source_selector.sources or {}
    local selector_has_branch = false
    for _, source in ipairs(opts.source_selector.sources) do
      if type(source) == "table" and source.source == "branch_diff" then
        selector_has_branch = true
        break
      end
    end
    if not selector_has_branch then
      table.insert(opts.source_selector.sources, { source = "branch_diff", display_name = " Branch Diff" })
    end

    require("neo-tree.sources.branch_diff")
    require("neo-tree").setup(opts)
  end,
}
