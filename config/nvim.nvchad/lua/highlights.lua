-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
    fg = "dark_purple",
  },
  -- Normal = {
  --   bg = { "black", -4 }
  -- },
}
-- M.ui = {
--    changed_themes = {
--       gruvbox = {
--          base_16 = {
--             base00 = "#mycol",
--          },
--          base_30 = {
--             red = "#mycol",
--             white = "#mycol",
--          },
--       },
--
--       nord = {
--          -- and so on!
--       },
--    },
-- }

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M
