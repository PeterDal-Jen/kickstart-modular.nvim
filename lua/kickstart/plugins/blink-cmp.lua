---@module 'lazy'
---@type LazySpec
return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },

      {'onsails/lspkind.nvim',},
      {'giuxtaposition/blink-cmp-copilot',},
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'normal',
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = { border = 'rounded' },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          border = 'rounded',
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
            treesitter = { 'lsp' },
            kind_icon = {
            text = function(ctx)
              return require('lspkind').symbol_map[ctx.kind] or ''
            end,
            },
          },
        },
      },

      -- My super-TAB configuration
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = {
          function(cmp)
            return cmp.select_next()
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = {
          function(cmp)
            return cmp.select_prev()
          end,
          'snippet_backward',
          'fallback',
        },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
      },

      -- Experimental signature help support
      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          lsp = {
            min_keyword_length = 2, -- Number of characters to trigger porvider
            score_offset = 0, -- Boost/penalize the score of the items
          },
          path = {
            min_keyword_length = 0,
          },
          snippets = {
            min_keyword_length = 2,
          },
          buffer = {
            min_keyword_length = 5,
            max_items = 5,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 0,
            async = true,
          },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
