local LazyVim = require("lazyvim.util")
local uv = vim.uv or vim.loop

local M = {}

local IGNORE_FILE = ".lazyvim.grep.ignore"
local TESTS_FILE = ".lazyvim.grep.tests"

local cache = {}

local function get_timestamp(stat)
  local mtime = stat and stat.mtime
  if type(mtime) == "table" then
    return string.format("%s.%s", mtime.sec or 0, mtime.nsec or 0)
  end
  return tostring(mtime or 0)
end

local function project_root(opts)
  opts = opts or {}
  if opts.cwd and opts.cwd ~= "" then
    return vim.fs.normalize(opts.cwd)
  end

  local root = LazyVim.root({ buf = opts.buf })
  if not root or root == "" then
    root = uv.cwd()
  end

  return vim.fs.normalize(root)
end

local function read_entries(path)
  path = vim.fs.normalize(path)
  local stat = uv.fs_stat(path)
  if not stat then
    cache[path] = nil
    return {}
  end

  local timestamp = get_timestamp(stat)
  local cached = cache[path]
  if cached and cached.timestamp == timestamp then
    return cached.entries
  end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return {}
  end

  local entries = {}
  for _, line in ipairs(lines) do
    local trimmed = vim.trim(line)
    if trimmed ~= "" and not trimmed:match("^#") then
      entries[#entries + 1] = trimmed:gsub("^%./", "")
    end
  end

  cache[path] = {
    timestamp = timestamp,
    entries = entries,
  }

  return entries
end

local function read_project_file(root, filename)
  return read_entries(vim.fs.joinpath(root, filename))
end

local function resolve_dirs(root, entries)
  local dirs = {}
  for _, entry in ipairs(entries) do
    local path = vim.fs.normalize(vim.fs.joinpath(root, entry))
    if uv.fs_stat(path) then
      dirs[#dirs + 1] = path
    end
  end
  return dirs
end

function M.grep(opts)
  opts = vim.deepcopy(opts or {})
  opts.cwd = project_root(opts)
  return Snacks.picker.grep(opts)
end

function M.grep_filtered(opts)
  opts = vim.deepcopy(opts or {})
  opts.cwd = project_root(opts)
  opts.exclude = read_project_file(opts.cwd, IGNORE_FILE)
  return Snacks.picker.grep(opts)
end

function M.grep_word_filtered(opts)
  opts = vim.deepcopy(opts or {})
  opts.cwd = project_root(opts)
  opts.exclude = read_project_file(opts.cwd, IGNORE_FILE)
  return Snacks.picker.grep_word(opts)
end

function M.grep_tests(opts)
  opts = vim.deepcopy(opts or {})
  opts.cwd = project_root(opts)

  local dirs = resolve_dirs(opts.cwd, read_project_file(opts.cwd, TESTS_FILE))
  if #dirs == 0 then
    vim.notify("No searchable test paths found in " .. TESTS_FILE, vim.log.levels.WARN)
    return
  end

  opts.dirs = dirs
  return Snacks.picker.grep(opts)
end

return M
