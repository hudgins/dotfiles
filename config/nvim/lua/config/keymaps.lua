-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- clipboard
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<leader>P', '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({'n', 'v'}, '<D-c>', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<D-v>', '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set('i', '<D-v>', '<ESC>"+p', { desc = "Paste from system clipboard" })

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
