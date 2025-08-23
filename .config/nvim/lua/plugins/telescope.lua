-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',

    -- Useful for getting pretty icons, but requires a Nerd Font.
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local actions = require 'telescope.actions'
    local builtin = require 'telescope.builtin'
    local function filenameFirst(_, path)
      local tail = vim.fs.basename(path)
      local parent = vim.fs.dirname(path)
      if parent == '.' then
        return tail
      end
      return string.format('%s\t\t%s', tail, parent)
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'TelescopeResults',
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd('TelescopeParent', '\t\t.*$')
          vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
        end)
      end,
    })

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous, -- move to prev result
            ['<C-j>'] = actions.move_selection_next, -- move to next result
            ['<C-l>'] = actions.select_default, -- open file
          },
          n = {
            ['q'] = actions.close,
          },
        },
        prompt_prefix = ' ',
        selection_caret = ' ',
        path_display = filenameFirst,
        dynamic_preview_title = true,
        layout_strategy = 'vertical',
        layout_config = {
          prompt_position = 'bottom',
          height = 0.95,
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { 'node_modules', '.git', '.venv' },
          hidden = true,
        },
        buffers = {
          initial_mode = 'insert',
          sort_lastused = true,
          -- sort_mru = true,
          mappings = {
            n = {
              ['d'] = actions.delete_buffer,
              ['l'] = actions.select_default,
            },
          },
        },
      },
      live_grep = {
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
        additional_args = function(_)
          return { '--hidden' }
        end,
      },

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
      git_files = {
        previewer = false,
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- general searching
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[s]earch [f]iles' })
    vim.keymap.set('n', '<leader>saf', builtin.find_files, { desc = '[s]earch [a]ll [f]iles' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch [g]rep' })
    vim.keymap.set('n', '<leader>sgw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[s]earch [m]arks' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp tags' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        previewer = false,
      })
    end, { desc = '[/] fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] search recently opened files' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[s]earch existing [b]uffers' })
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'live grep in open files',
      }
    end, { desc = '[s]earch [/] in Open Files' })

    -- git maps
    vim.keymap.set('n', '<leader>sgf', builtin.git_files, { desc = 'search [g]it [f]iles' })
    vim.keymap.set('n', '<leader>sgc', builtin.git_commits, { desc = 'search [g]it [c]ommits' })
    vim.keymap.set('n', '<leader>sgcf', builtin.git_bcommits, { desc = 'search [g]it [c]ommits for current [f]ile' })
    vim.keymap.set('n', '<leader>sgb', builtin.git_branches, { desc = 'search [g]it [b]ranches' })
    vim.keymap.set('n', '<leader>sgs', builtin.git_status, { desc = 'search [g]it [s]tatus (diff view)' })
  end,
}
