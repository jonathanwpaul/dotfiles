return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'stevearc/conform.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'j-hui/fidget.nvim',
  },

  config = function()
    local cmp = require 'cmp'
    local cmp_lsp = require 'cmp_nvim_lsp'
    local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
    local telescope = require 'telescope.builtin'

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('init_lsp', {}),
      callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set('n', 'gd', function()
          telescope.lsp_definitions()
        end, opts)
        vim.keymap.set('n', 'gr', function()
          telescope.lsp_references()
        end, opts)
        vim.keymap.set('n', '<C-Space>', function()
          vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set('n', '<leader>lca', function()
          vim.lsp.buf.code_action()
        end, opts)

        vim.keymap.set('n', '<leader>ld', telescope.diagnostics, { desc = '[s]earch [d]iagnostics' })
        vim.keymap.set('n', '<leader>ls', function()
          telescope.builtin.lsp_document_symbols {
            symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
          }
        end, { desc = '[s]earch lsp document [s]ymbols' })

        vim.keymap.set('n', '<leader>lrn', function()
          vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set('i', '<C-h>', function()
          vim.lsp.buf.signature_help()
        end, opts)
        vim.keymap.set('n', ']d', function()
          vim.diagnostic.goto_next()
        end, opts)
        vim.keymap.set('n', '[d', function()
          vim.diagnostic.goto_prev()
        end, opts)
        vim.keymap.set('n', 'K', function()
          vim.diagnostic.open_float()
        end, opts)
      end,
    })

    require('fidget').setup {}
    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = {
        'ts_ls',
        'lua_ls',
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
          }
        end,
        clangd = function()
          require('lspconfig').clangd.setup {
            arguments = { '--compile-commands-dir=.' },
            capabilities = capabilities,
            -- Optionally, add more settings here
          }
        end,

        -- zls = function()
        --   local lspconfig = require 'lspconfig'
        --   lspconfig.zls.setup {
        --     root_dir = lspconfig.util.root_pattern('.git', 'build.zig', 'zls.json'),
        --     settings = {
        --       zls = {
        --         enable_inlay_hints = true,
        --         enable_snippets = true,
        --         warn_style = true,
        --       },
        --     },
        --   }
        --   vim.g.zig_fmt_parse_errors = 0
        --   vim.g.zig_fmt_autosave = 0
        -- end,
        lua_ls = function()
          local lspconfig = require 'lspconfig'
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {

              Lua = {
                diagnostics = {
                  globals = { 'vim' },
                },
                format = {
                  enable = true,
                  -- Put format options here
                  -- NOTE: the value should be STRING!!
                  defaultConfig = {
                    indent_style = 'space',
                    indent_size = '2',
                  },
                },
              },
            },
          }
        end,
      },
    }

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert {
        -- ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        -- ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        -- ['<expand>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'copilot', group_index = 2 },
        { name = 'luasnip', group_index = 3 }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      }),
    }

    vim.diagnostic.config {
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
      },
    }
  end,
}
