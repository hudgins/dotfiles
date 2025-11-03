local utils = require("neo-tree.utils")
local uv = vim.uv or vim.loop
local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
local events = require("neo-tree.events")

-- Configuration defaults for the custom Branch Diff source. Every key here can
-- be overridden via `opts.branch_diff` in the user's Neo-tree setup.

local default_config = {
  base_ref = nil,
  remote = "origin",
  include_untracked = true,
  git_diff_args = { "--find-renames" },
  fallback_refs = nil,
}

-- Metadata used by Neo-tree to register the source.
local M = {
  name = "branch_diff",
  display_name = " Branch Diff",
}

-- Lightweight table emptiness check so we can guard fallback lists without
-- allocating intermediary structures.
local function tbl_isempty(tbl)
  return not tbl or next(tbl) == nil
end

-- Invoke git with consistent working-directory and exit-code handling. Git
-- returns exit code 1 for "diff found", so callers can whitelist additional
-- codes via opts.valid_exit_codes.
local function run_git(args, opts)
  opts = opts or {}
  local cmd = { "git" }
  if opts.cwd and opts.cwd ~= "" then
    table.insert(cmd, "-C")
    table.insert(cmd, opts.cwd)
  end
  vim.list_extend(cmd, args)
  local result = vim.fn.systemlist(cmd)
  local exit_code = vim.v.shell_error or 0
  local allowed = opts.valid_exit_codes or { 0 }
  local ok = false
  for _, code in ipairs(allowed) do
    if exit_code == code then
      ok = true
      break
    end
  end
  if not ok then
    local message = table.concat(result, "\n")
    if message == "" then
      message = table.concat(cmd, " ")
    end
    return nil, message, exit_code
  end
  return result
end

-- Decide which directory to treat as the active repo. Preference order:
--   1. currently focused buffer
--   2. existing state.path supplied by Neo-tree
--   3. current working directory
local function get_git_workdir(state)
  local function normalize(path)
    if not path or path == "" then
      return nil
    end
    local stat = uv.fs_stat(path)
    if stat and stat.type == "file" then
      return vim.fn.fnamemodify(path, ":p:h")
    end
    return vim.fn.fnamemodify(path, ":p")
  end

  local buf = vim.api.nvim_get_current_buf()
  if buf and buf > 0 then
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" then
      local path = normalize(name)
      if path then
        return path
      end
    end
  end

  if state and state.path and state.path ~= "" then
    local path = normalize(state.path)
    if path then
      return path
    end
  end
  return vim.fn.getcwd()
end

-- Resolve the root of the git repository we are diffing.
local function get_repo_root(state)
  local workdir = get_git_workdir(state)
  local output, err = run_git({ "rev-parse", "--show-toplevel" }, { cwd = workdir })
  if not output or not output[1] or output[1] == "" then
    return nil, err or "Not inside a Git repository"
  end
  return output[1]
end

-- Provide a friendly branch name for the tree header (falls back to "HEAD").
local function get_head_branch(repo_root)
  local output = run_git({ "rev-parse", "--abbrev-ref", "HEAD" }, { cwd = repo_root })
  if not output or not output[1] or output[1] == "" then
    return nil
  end
  return output[1]
end

-- Given a remote name (defaults to origin), return the branch its symbolic HEAD
-- points to (e.g. origin/main). Nil if not set.
local function resolve_remote_head(remote, repo_root)
  if not remote or remote == "" then
    return nil
  end
  local output = run_git({ "rev-parse", "--abbrev-ref", remote .. "/HEAD" }, { cwd = repo_root })
  if output and output[1] and output[1] ~= "" then
    return output[1]
  end
  return nil
end

local function resolve_base_ref(config, repo_root)
  local configured = config.base_ref
  if configured and configured ~= "" then
    return configured
  end

  local remote = config.remote or default_config.remote
  local remote_head = resolve_remote_head(remote, repo_root)
  if remote_head then
    return remote_head
  end

  local fallbacks = config.fallback_refs
  if not fallbacks or tbl_isempty(fallbacks) then
    local remote_name = remote or "origin"
    fallbacks = { remote_name .. "/main", remote_name .. "/master" }
  end

  for _, ref in ipairs(fallbacks) do
    if ref and ref ~= "" then
      local check = run_git({ "show-ref", "--verify", "--quiet", "refs/remotes/" .. ref }, { cwd = repo_root })
      if check ~= nil then
        return ref
      end
    end
  end

  local upstream, upstream_err = run_git(
    { "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}" },
    { cwd = repo_root }
  )
  if upstream and upstream[1] and upstream[1] ~= "" then
    return upstream[1]
  end

  return nil, upstream_err or "Unable to determine upstream reference"
end

local function collect_diff_entries(base_ref, config, repo_root)
  local args = { "diff", "--name-status" }
  for _, argument in ipairs(config.git_diff_args or default_config.git_diff_args) do
    table.insert(args, argument)
  end
  table.insert(args, base_ref .. "...HEAD")

  local lines, err = run_git(args, { cwd = repo_root, valid_exit_codes = { 0, 1 } })
  if not lines then
    return nil, err
  end

  local entries = {}
  for _, line in ipairs(lines) do
    if line ~= "" then
      local parts = vim.split(line, "\t", { plain = true })
      local raw_status = parts[1]
      if raw_status and raw_status ~= "" then
        -- The first character tells us the high-level change (A/M/D/etc.).
        local status = raw_status:sub(1, 1)
        local old_path, new_path
        if #parts == 2 then
          new_path = parts[2]
        elseif #parts >= 3 then
          old_path = parts[2]
          new_path = parts[3]
        end
        local relative_path = new_path or old_path
        if relative_path and relative_path ~= "" then
          table.insert(entries, {
            status = status,
            raw_status = raw_status,
            relative_path = relative_path,
            previous_path = old_path,
            base_ref = base_ref,
          })
        end
      end
    end
  end

  if config.include_untracked ~= false then
    local untracked = run_git({ "ls-files", "--others", "--exclude-standard" }, { cwd = repo_root })
    if untracked then
      for _, path in ipairs(untracked) do
        if path ~= "" then
          -- Treat untracked files as git status "??" so components/commands can
          -- present them like standard git_status entries.
          table.insert(entries, {
            status = "?",
            raw_status = "??",
            relative_path = path,
            previous_path = nil,
            base_ref = base_ref,
            is_untracked = true,
          })
        end
      end
    end
  end

  return entries
end

-- Guarantee directories have a children array when we need to append new node.
local function ensure_children(node)
  if not node.children then
    node.children = {}
  end
  return node.children
end

-- Recursive sort to keep Neo-tree's ordering stable every refresh.
local function sort_children(node)
  if not node or not node.children then
    return
  end
  table.sort(node.children, function(a, b)
    if a.type == b.type then
      return a.name:lower() < b.name:lower()
    end
    return a.type == "directory"
  end)
  for _, child in ipairs(node.children) do
    sort_children(child)
  end
end

-- Turn the flat git output into a full Neo-tree node hierarchy.
local function build_tree(entries, repo_root)
  local repo_name = vim.fn.fnamemodify(repo_root, ":t")
  local root = {
    id = repo_root,
    name = repo_name,
    path = repo_root,
    type = "directory",
    children = {},
    loaded = true,
  }
  local nodes = { [repo_root] = root }
  local expanded = { [repo_root] = true }

  for _, entry in ipairs(entries) do
    -- Split each file path and walk it downward, creating intermediate
    -- directories as needed so we mirror the repo structure.
    local parts = vim.split(entry.relative_path, "/", { plain = true, trimempty = true })
    if #parts > 0 then
      local parent = root
      local current_path = repo_root
      for index, part in ipairs(parts) do
        current_path = utils.path_join(current_path, part)
        local existing = nodes[current_path]
        if index == #parts then
          if not existing or existing.type ~= "file" then
            entry.absolute_path = current_path
            local file_node = {
              id = current_path,
              name = part,
              path = current_path,
              type = "file",
              extra = {
                branch_diff = entry,
                git_status = entry.status,
              },
            }
            nodes[current_path] = file_node
            ensure_children(parent)
            table.insert(parent.children, file_node)
          else
            entry.absolute_path = existing.path
            existing.extra = existing.extra or {}
            existing.extra.branch_diff = entry
            existing.extra.git_status = entry.status
          end
        else
          if not existing or existing.type ~= "directory" then
            local dir_node = {
              id = current_path,
              name = part,
              path = current_path,
              type = "directory",
              children = {},
              loaded = true,
            }
            nodes[current_path] = dir_node
            ensure_children(parent)
            table.insert(parent.children, dir_node)
          end
          parent = nodes[current_path]
          expanded[parent.id] = true
        end
      end
    end
  end

  sort_children(root)
  return root, expanded
end

-- Convenience helper so both the Neo-tree panel and the command line show
-- identical status information when something goes wrong.
local function show_message(state, message, level)
  renderer.show_nodes({
    {
      id = "branch_diff::message",
      name = message,
      type = "message",
      path = state.path or "",
    },
  }, state)
  if message and message ~= "" then
    vim.notify(message, level or vim.log.levels.WARN, { title = "Neo-tree Branch Diff" })
  end
end

-- Our config pipeline mirrors the built-in sources: defaults -> global setup ->
-- per-state overrides (mostly coming from the user's opts.branch_diff table).
local function merge_config(state)
  local merged = vim.tbl_deep_extend("force", {}, default_config)
  if M.config then
    merged = vim.tbl_deep_extend("force", merged, M.config)
  end
  if state.config then
    merged = vim.tbl_deep_extend("force", merged, state.config)
  end
  return merged
end

function M.navigate(state)
  -- All git interaction happens synchronously, so mark the state as clean to
  -- avoid Neo-tree showing a lingering "loading" state.
  state.dirty = false

  local repo_root, root_err = get_repo_root(state)
  if not repo_root then
    show_message(state, root_err or "Not inside a Git repository", vim.log.levels.WARN)
    return
  end

  state.path = repo_root
  local config = merge_config(state)

  local base_ref, base_err = resolve_base_ref(config, repo_root)
  if not base_ref then
    show_message(state, base_err or "Unable to determine base branch", vim.log.levels.WARN)
    return
  end

  local entries, diff_err = collect_diff_entries(base_ref, config, repo_root)
  if not entries then
    show_message(state, diff_err or "Failed to collect diff information", vim.log.levels.ERROR)
    return
  end

  local branch_name = get_head_branch(repo_root) or "HEAD"
  local root, expanded = build_tree(entries, repo_root)
  root._is_expanded = true
  root.extra = root.extra or {}
  -- Surface comparison metadata so components/commands can access it without
  -- recomputing the branch info.
  root.extra.branch_diff = {
    base_ref = base_ref,
    branch = branch_name,
  }

  if #entries == 0 then
    root.children = {
      {
        id = repo_root .. "::clean",
        name = string.format("No changes relative to %s", base_ref),
        type = "message",
        path = repo_root,
      },
    }
  end

  local label_repo = vim.fn.fnamemodify(repo_root, ":t")
  -- Show both branch names in the root node so users immediately know what is
  -- being compared.
  root.name = string.format("%s (%s ↔ %s)", label_repo, branch_name, base_ref)

  local default_expanded = { root.id }
  for id in pairs(expanded or {}) do
    if id ~= root.id then
      table.insert(default_expanded, id)
    end
  end
  -- Remember which nodes should start expanded the next time the source opens.
  state.default_expanded_nodes = default_expanded
  -- Persist summary info so other parts of the source can present it (e.g. the
  -- renderer's title or status component).
  state.branch_diff = {
    base_ref = base_ref,
    branch = branch_name,
    repo_root = repo_root,
    config = config,
  }

  renderer.show_nodes({ root }, state)
end

function M.refresh()
  manager.refresh(M.name)
end

function M.setup(config, global_config)
  M.config = vim.tbl_deep_extend("force", {}, default_config, config or {})

  local function request_refresh()
    -- Use a short debounce so multiple git events collapse into a single
    -- refresh operation. This keeps the UI responsive on large repos.
    utils.debounce(
      "branch_diff_refresh",
      function()
        manager.refresh(M.name)
      end,
      120,
      utils.debounce_strategy.CALL_LAST_ONLY
    )
  end

  manager.subscribe(M.name, {
    event = events.GIT_EVENT,
    -- External git actions (pull, commit, etc.) emit this event so we keep the
    -- diff list up to date even when changes happen outside Neovim.
    handler = request_refresh,
  })

  if global_config.enable_refresh_on_write then
    manager.subscribe(M.name, {
      event = events.VIM_BUFFER_CHANGED,
      -- Buffer writes can produce git changes (e.g. new staging candidates). We
      -- reuse the same debounce so a flurry of writes only triggers one refresh.
      handler = request_refresh,
    })
  end
end

M.components = require("neo-tree.sources.branch_diff.components")
M.commands = require("neo-tree.sources.branch_diff.commands")

return M
