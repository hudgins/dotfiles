-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
local g = vim.g
local opt = vim.opt

-- neovide
g.neovide_cursor_vfx_mode = "railgun" -- torpedo, railgun, pixiedust, wireframe, ripple, sonicboom, 
g.neovide_cursor_smooth_blink = false -- performance hit of nearly 15x
-- g.neovide_transparency = 0.8

-- pico-8
-- g.pico8_config.imitate_console = 0

opt.clipboard = ""
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.wrap = false

-- opt.guicursor = vim.tbl_deep_extend("force", opt.guicursor, guicursor)
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,n:blinkon3000,n:blinkoff100,n:blinkwait1000"

-- opt.gfn = "Iosevka Nerd Font:h18"
-- g.ezguifont = "Iosevka Nerd Font:h18"
opt.gfn = "VictorMono Nerd Font Mono:h18"
g.ezguifont = "VictorMono Nerd Font Mono:h18"

