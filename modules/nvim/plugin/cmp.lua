local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = {
      max_width = 50,
      border = "none",
      scrollbar = false,
    },
    documentation = {
      border = "none",
      max_height = 15,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),

    -- Scroll up and down in the completion documentation
    ["<A-j>"] = cmp.mapping.select_next_item(),
    ["<A-k>"] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})


-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})
