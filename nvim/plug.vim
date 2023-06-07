if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'gruvbox-community/gruvbox' " colorscheme
Plug 'tssm/c64-vim-color-scheme' " colorscheme
Plug 'tpope/vim-commentary' " gc motion to comment out lines
Plug 'junegunn/vim-easy-align' " ga motion to align text/dicts/etc
Plug 'wakatime/vim-wakatime'
Plug 'airblade/vim-gitgutter' " git status per line in the gutter
Plug 'farmergreg/vim-lastplace' " restore last edit position when re-opening a file
Plug 'foosoft/vim-argwrap' " toggle whether arglists and object literals are on new lines
Plug 'mhinz/vim-startify' " fancy start screen with MRU files

if has("nvim")
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lspconfig'
  " Plug 'tami5/lspsaga.nvim', { 'branch': 'nvim6.0' }
  Plug 'folke/lsp-colors.nvim'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'onsails/lspkind-nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

  Plug 'stevearc/aerial.nvim'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
  " Plug 'github/copilot.vim'

"  Plug 'windwp/nvim-autopairs'
"  Plug 'windwp/nvim-ts-autotag'
endif

Plug 'groenewege/vim-less', { 'for': 'less' }
" Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()

