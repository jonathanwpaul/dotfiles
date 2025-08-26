require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Import color theme based on environment variable NVIM_THEME
local default_color_scheme = 'rosepine'
local env_var_nvim_theme = os.getenv 'NVIM_THEME' or default_color_scheme

-- Define a table of theme modules
local themes = {
  rosepine = 'themes.rose-pine',
  nord = 'themes.nord',
  onedark = 'themes.onedark',
  catppuccin = 'themes.catppuccin',
  nightfox = 'themes.nightfox',
}

if vim.g.vscode then
  -- VSCode Neovim
  require 'core.vscode_keymaps'
  require('lazy').setup {
    { import = 'plugins.motions' },
    { import = 'plugins.surround' },
    { import = 'plugins.undotree' },
  }
else
  -- Ordinary Neovim

  -- Setup plugins
  require('lazy').setup {
    spec = {
      { import = 'plugins' },
      { import = themes[env_var_nvim_theme] },
    },
    ui = {
      -- If you have a Nerd Font, set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  }

  -- Function to check if a file exists
  local function file_exists(file)
    local f = io.open(file, 'r')
    if f then
      f:close()
      return true
    else
      return false
    end
  end

  -- Path to the session file
  local session_file = '.session.vim'

  -- Check if the session file exists in the current directory
  if file_exists(session_file) then
    -- Source the session file
    vim.cmd('source ' .. session_file)
  end

  --
  -- Telescope verbose map
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local function get_verbose_maps()
    local maps = vim.api.nvim_exec2('verbose map', { output = true }).output
    local lines = {}
    for line in maps:gmatch '[^\r\n]+' do
      table.insert(lines, line)
    end
    return lines
  end

  local function verbose_maps_picker()
    pickers
      .new({}, {
        prompt_title = 'Verbose Keymaps',
        finder = finders.new_table {
          results = get_verbose_maps(),
        },
        sorter = conf.generic_sorter {},
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
          end)
          return true
        end,
      })
      :find()
  end

  vim.api.nvim_create_user_command('TelescopeVerboseMaps', verbose_maps_picker, {}) --
end
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
