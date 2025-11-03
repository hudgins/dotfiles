local highlights = require("neo-tree.ui.highlights")
local common = require("neo-tree.sources.common.components")

-- Extend the default Neo-tree components with branch-diff aware styling. We
-- reuse the existing highlight groups so the output looks consistent with the
-- built-in git status source.

local status_icons = {
  A = "",
  M = "",
  D = "",
  R = "",
  T = "",
  C = "",
  ["?"] = "",
}

local status_highlights = {
  A = highlights.GIT_ADDED,
  M = highlights.GIT_MODIFIED,
  D = highlights.GIT_DELETED,
  R = highlights.GIT_RENAMED,
  C = highlights.GIT_CONFLICT,
  ["?"] = highlights.GIT_UNTRACKED,
}

-- Pull the diff metadata we attached in init.lua off the node so multiple
-- components can share the same lookup logic.
local function status_data(node)
  local extra = node.extra or {}
  local diff = extra.branch_diff
  if not diff or not diff.status then
    return nil
  end
  local status = diff.status
  return {
    status = status,
    icon = status_icons[status] or status_icons.M,
    highlight = status_highlights[status] or highlights.FILE_ICON,
    raw_status = diff.raw_status or status,
    diff = diff,
  }
end

local components = vim.tbl_deep_extend("force", {}, common)

components.git_status = function(config, node, state)
  local data = status_data(node)
  if not data then
    return {}
  end

  local symbols = config.symbols or {}
  local status = data.status
  local text = symbols[status]
  if not text then
    -- Fall back to sensible defaults when the user did not provide custom
    -- glyphs for every possible status code.
    if status == "?" then
      text = symbols.untracked or "??"
    elseif status == "A" then
      text = symbols.added or status
    elseif status == "M" then
      text = symbols.modified or status
    elseif status == "D" then
      text = symbols.deleted or status
    elseif status == "R" then
      text = symbols.renamed or status
    elseif status == "C" then
      text = symbols.conflict or status
    else
      text = status
    end
  end

  return {
    text = text,
    highlight = data.highlight or highlights.GIT_MODIFIED,
  }
end

components.icon = function(config, node, state)
  if node.type == "directory" or node.type == "message" then
    return common.icon(config, node, state)
  end
  local data = status_data(node)
  if not data then
    return common.icon(config, node, state)
  end
  -- Prefix the filename with the git status glyph (keeping the trailing space
  -- that Neo-tree expects for alignment with other sources).
  return {
    text = data.icon .. " ",
    highlight = data.highlight or highlights.FILE_ICON,
  }
end

return components
