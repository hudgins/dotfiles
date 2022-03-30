if !exists('g:loaded_cmp') | finish | endif

set completeopt=menuone,noinsert,noselect

lua <<EOF
  local cmp = require'cmp'
  local lspkind = require'lspkind'

  local timer = vim.loop.new_timer()

  local DEBOUNCE_DELAY = 1000

  function debounce()
    timer:stop()
    timer:start(
      DEBOUNCE_DELAY,
      0,
      vim.schedule_wrap(function()
        cmp.complete({ reason = cmp.ContextReason.Auto })
      end)
    )
  end

  cmp.setup({
    completion = {
      autocomplete = false, -- disable auto-completion.
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true
      }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      format = lspkind.cmp_format({with_text = false, maxwidth = 50})
    }
  })

  vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]
  
  -- NOTE: change "plugin.cmp.debounce" to location of debounce.lua
  -- If it's in the lua folder, then change to "debounce"

  vim.cmd([[
    augroup CmpDebounceAuGroup
      au!
      au TextChangedI * lua debounce()
    augroup end
  ]])
EOF
" vim.cmd([[
"   inoremap <C-p> <Cmd>lua vimrc.cmp.lsp()<CR>
"   inoremap <C-x><C-s> <Cmd>lua vimrc.cmp.snippet()<CR>
" ]])

" _G.vimrc = _G.vimrc or {}
" _G.vimrc.cmp = _G.vimrc.cmp or {}
" _G.vimrc.cmp.lsp = function()
"   cmp.complete({
"     config = {
"       sources = {
"         { name = 'nvim_lsp' }
"       }
"     }
"   })
" end
" _G.vimrc.cmp.snippet = function()
"   cmp.complete({
"     config = {
"       sources = {
"         { name = 'vsnip' }
"       }
"     }
"   })
" end

" vim.cmd([[
"   inoremap <C-p> <Cmd>lua vimrc.cmp.lsp()<CR>
"   inoremap <C-x><C-s> <Cmd>lua vimrc.cmp.snippet()<CR>
" ]])
