local LazyVim = require("lazyvim.util")
local uv = vim.uv or vim.loop

local M = {}

local ignore_cache = {}

local function find_ignore_file(cwd)
  cwd = cwd or uv.cwd()
  local found = vim.fs.find(".nvim_default_ignore", {
    path = cwd,
    upward = true,
  })
  return found[1]
end

local function read_ignore_entries(cwd)
  local candidates = {}
  local seen = {}

  local function add_candidate(path)
    if path and path ~= "" then
      path = vim.fs.normalize(path)
      if not seen[path] then
        seen[path] = true
        candidates[#candidates + 1] = path
      end
    end
  end

  add_candidate(cwd)
  add_candidate(uv.cwd())

  for _, start in ipairs(candidates) do
    local file = find_ignore_file(start)
    if file then
      file = vim.fs.normalize(file)
      local stat = uv.fs_stat(file)
      if not stat then
        ignore_cache[file] = nil
      else
        local timestamp = string.format("%s.%s", stat.mtime.sec or stat.mtime, stat.mtime.nsec or 0)
        local cached = ignore_cache[file]
        if cached and cached.timestamp == timestamp then
          return cached.entries
        end

        local ok, lines = pcall(vim.fn.readfile, file)
        if not ok then
          return {}
        end

        local entries = {}
        for _, line in ipairs(lines) do
          local trimmed = line:match("^%s*(.-)%s*$")
          if trimmed ~= "" and not trimmed:match("^#") then
            entries[#entries + 1] = trimmed:gsub("^%./", "")
          end
        end

        ignore_cache[file] = {
          timestamp = timestamp,
          entries = entries,
        }

        return entries
      end
    end
  end

  return {}
end

local function shellescape(value)
  return vim.fn.shellescape(value)
end

local function append_fd_opts(base, entries)
  if not entries or #entries == 0 then
    return base
  end
  local parts = { base or "" }
  for _, entry in ipairs(entries) do
    parts[#parts + 1] = "--exclude " .. shellescape(entry)
  end
  return table.concat(parts, " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalized_globs(entry)
  local results = {}
  local trimmed = entry

  local has_wildcards = trimmed:find("[%*%?%[]") ~= nil
  if trimmed:sub(-1) == "/" then
    trimmed = trimmed:sub(1, -2)
  end

  results[#results + 1] = trimmed

  if not has_wildcards then
    results[#results + 1] = trimmed .. "/**"
  end

  return results
end

local function append_rg_opts(base, entries)
  if not entries or #entries == 0 then
    return base
  end

  local prefix, suffix = base or "", ""
  local trimmed = vim.trim(prefix)
  if trimmed:sub(-2) == "-e" then
    prefix = vim.trim(trimmed:sub(1, -3))
    suffix = " -e"
  else
    prefix = trimmed
  end

  local parts = { prefix }
  for _, entry in ipairs(entries) do
    for _, glob in ipairs(normalized_globs(entry)) do
      parts[#parts + 1] = "--glob " .. shellescape("!" .. glob)
    end
  end

  return table.concat(vim.tbl_filter(function(part)
    return part and #part > 0
  end, parts), " ") .. suffix
end

local function make_file_ignore_patterns(entries)
  local patterns = {}
  for _, entry in ipairs(entries) do
    local trimmed = entry:gsub("/+$", "")
    if trimmed ~= "" then
      local escaped = vim.pesc(trimmed)
      patterns[#patterns + 1] = "^" .. escaped .. "$"
      patterns[#patterns + 1] = "^" .. escaped .. "/"
    end
  end
  return patterns
end

local function apply_ignore(command, opts)
  local entries = read_ignore_entries(opts.cwd)
  if #entries == 0 then
    return opts
  end

  local ok, config = pcall(require, "fzf-lua.config")
  if not ok then
    return opts
  end

  if command == "files" then
    local files_cfg = config.globals.files or {}
    local base_fd = opts.fd_opts or files_cfg.fd_opts or ""
    local base_rg = opts.rg_opts or files_cfg.rg_opts or ""
    opts.fd_opts = append_fd_opts(base_fd, entries)
    opts.rg_opts = append_rg_opts(base_rg, entries)
    opts.file_ignore_patterns = make_file_ignore_patterns(entries)
  elseif command == "live_grep" then
    local lgrep_cfg = config.globals.live_grep or config.globals.grep or {}
    local base_rg = opts.rg_opts or lgrep_cfg.rg_opts or ""
    opts.rg_opts = append_rg_opts(base_rg, entries)
  end

  return opts
end

local function resolve_root(opts)
  if opts.cwd then
    return opts.cwd
  end
  if opts.root == false then
    local cwd = uv.cwd()
    opts.cwd = cwd
    return cwd
  end
  opts.cwd = LazyVim.root({ buf = opts.buf })
  if opts.cwd == "" or not opts.cwd then
    opts.cwd = uv.cwd()
  end
  return opts.cwd
end

function M.open(command, opts, include_ignore)
  opts = vim.deepcopy(opts or {})
  resolve_root(opts)
  if include_ignore ~= false then
    opts = apply_ignore(command, opts)
  end
  LazyVim.pick.open(command, opts)
end

function M.files(opts, include_ignore)
  return M.open("files", opts, include_ignore)
end

function M.live_grep(opts, include_ignore)
  return M.open("live_grep", opts, include_ignore)
end

return M
