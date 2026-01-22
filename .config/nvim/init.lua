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

-- Check if 'pwsh' (PowerShell Core) is executable and set the shell accordingly
if vim.fn.executable 'pwsh' == 1 then
  vim.opt.shellcmdflag = '-NoExit -Command'
  vim.o.shell = 'pwsh'
elseif vim.fn.executable 'powershell' == 1 then
  -- Fallback to Windows PowerShell if pwsh is not found
  vim.opt.shellcmdflag = '-NoExit -Command'
  vim.o.shell = 'powershell'
else
  vim.o.shell = 'zsh'
end

-- Import color theme based on environment variable NVIM_THEME
local default_color_scheme = 'catppuccin'
local env_var_nvim_theme = os.getenv 'NVIM_THEME' or default_color_scheme

-- Define a table of theme modules
local themes = {
  rosepine = 'themes.rose-pine',
  nord = 'themes.nord',
  onedark = 'themes.onedark',
  catppuccin = 'themes.catppuccin',
  nightfox = 'themes.nightfox',
}

if vim.g.neovide then
  vim.g.neovide_title_background_color = string.format('%x', vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name 'Normal' }).bg)
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_fullscreen = true
  vim.o.guifont = 'CaskaydiaCove Nerd Font'

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set('n', '<C-=>', function()
    change_scale_factor(1.1)
  end)
  vim.keymap.set('n', '<C-->', function()
    change_scale_factor(1 / 1.1)
  end)
end

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
