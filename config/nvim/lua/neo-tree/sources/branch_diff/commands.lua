local utils = require("neo-tree.utils")
local manager = require("neo-tree.sources.manager")
local common = require("neo-tree.sources.common.commands")

local M = {}

local refresh = utils.wrap(manager.refresh, "branch_diff")

local function get_current_node(state)
  local tree = state.tree
  if not tree then
    return nil
  end
  local success, node = pcall(tree.get_node, tree)
  if success then
    return node
  end
  return nil
end

local function notify_deleted(diff)
  local path = diff and (diff.relative_path or diff.previous_path) or ""
  local message = path ~= "" and string.format("File was deleted: %s", path) or "File was deleted"
  vim.notify(message, vim.log.levels.WARN, { title = "Neo-tree Branch Diff" })
end

local function open_with(cmd)
  return function(state)
    local node = get_current_node(state)
    if not node then
      return
    end
    if node.type == "directory" then
      common.toggle_node(state)
      return
    end
    if node.type ~= "file" then
      return
    end

    local diff = node.extra and node.extra.branch_diff
    if diff and diff.status == "D" then
      notify_deleted(diff)
      return
    end

    common.revert_preview()
    utils.open_file(state, node.path, cmd)
  end
end

M.open = open_with("edit")
M.open_split = open_with("split")
M.open_vsplit = open_with("vsplit")
M.open_tabnew = open_with("tabnew")
M.open_drop = open_with("drop")
M.open_tab_drop = open_with("tab drop")
M.refresh = refresh

common._add_common_commands(M)

return M
