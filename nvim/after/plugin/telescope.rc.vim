if !exists('g:loaded_telescope') | finish | endif

nnoremap <silent> <Leader>j <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <silent> <Leader>k <cmd>lua require('telescope.builtin').find_files({ cwd='~/work' })<cr>
nnoremap <silent> <Leader>h <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <silent> <Leader>g <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap <silent> <Leader>b <cmd>Telescope buffers<cr>
nnoremap <silent> <Leader>i <cmd>Telescope help_tags<cr>

lua << EOF
function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')

EOF


