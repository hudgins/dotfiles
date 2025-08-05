-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g = vim.g
local opt = vim.opt

opt.clipboard = ""
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.wrap = false
opt.cursorline = false

g.autoformat = false
g.fzf_history_dir = "~/.local/share/fzf-history"

-- neovide
g.neovide_cursor_vfx_mode = "railgun" -- torpedo, railgun, pixiedust, wireframe, ripple, sonicboom,
g.neovide_cursor_smooth_blink = false -- performance hit of nearly 15x
g.neovide_transparency = 0.8
g.neovide_window_blurred = true
g.neovide_scroll_animation_far_lines = 0
g.neovide_hide_mouse_when_typing = true
g.neovide_scroll_animation_length = 0
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,n:blinkon3000,n:blinkoff100,n:blinkwait1000"

-- opt.gfn = "Iosevka Nerd Font:h18"
-- g.ezguifont = "Iosevka Nerd Font:h18"
-- opt.gfn = "VictorMono Nerd Font Mono:h18"
-- g.ezguifont = "VictorMono Nerd Font Mono:h18"
-- opt.gfn = "VictorMono Nerd Font Mono:h18"
-- g.ezguifont = "VictorMono Nerd Font Mono:h18"

-- pico-8
-- g.pico8_config.imitate_console = 0

-- php
vim.g.lazyvim_php_lsp = "intelephense"
-- vim.lsp.set_log_level("debug")
-- tail -f ~/.local/state/nvim/lsp.log | grep wp-content
