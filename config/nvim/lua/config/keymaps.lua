-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- clipboard
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<leader>P', '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({'n', 'v'}, '<D-c>', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<D-v>', '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set('i', '<D-v>', '<ESC>"+p', { desc = "Paste from system clipboard" })
vim.keymap.set('n', '<leader>yy', ':let @+ = @"<CR>', { desc = "Copy last yank to system clipboard" })
vim.keymap.set('n', '<leader>yp', ':let @+ = fnamemodify(expand("%"), ":.")<CR>', { desc = "Copy relative file path to system clipboard" })

-- vim.keymap.set('n', '<leader>z', '<cmd>CellularAutomaton make_it_rain<CR>', { desc = "Make it rain!" })

-- make simple blame as gb and move the others
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<CR>', { desc = "Git blame line" })
vim.keymap.set('n', '<leader>gB', function() Snacks.git.blame_line() end, { desc = "Git blame line - bigger" })
vim.keymap.set({'n', 'v'}, '<leader>gH', function() Snacks.gitbrowse() end, { desc = "Git Browse" })

-- save
vim.keymap.set('n', '<D-s>', '<cmd>update<CR>', { desc = "Save file if changed" })
vim.keymap.set('n', '<leader><space>', '<cmd>update<CR>', { desc = "Save file if changed" })
vim.keymap.set('n', '<D-S-s>', '<cmd>wall<CR>', { desc = "Save all changed files" })
vim.keymap.set('n', '<leader><enter>', '<cmd>wall<CR>', { desc = "Save all changed files" })

-- window navigation
-- part of the reason to map these is that I am using SuperKey to rebind ctrl+hjkl to the arrow keys
-- so mapping the arrow keys to the window navigation restores my expectd ctrl+hjkl Vim behaviour
-- but I'm not actually sure if I had that behaviour configured or not, can't find it anywhere
vim.keymap.set('n', '<up>', '<C-w>k', { desc = "Go to the up window" })
vim.keymap.set('n', '<down>', '<C-w>j', { desc = "Go to the down window" })
vim.keymap.set('n', '<left>', '<C-w>h', { desc = "Go to the left window" })
vim.keymap.set('n', '<right>', '<C-w>l', { desc = "Go to the right window" })

vim.keymap.set('n', '<S-x>', vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- weird little one-offs
vim.keymap.set('n', '<leader>mc', 'cw✅<esc>', { desc = "Check this off" })
