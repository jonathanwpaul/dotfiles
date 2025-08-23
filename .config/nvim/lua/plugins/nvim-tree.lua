return {
  'nvim-tree/nvim-tree.lua',
  enabled = false,
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '\\', ':NvimTreeToggle<CR>', desc = 'NvimTree toggle', silent = true },
  },
  opts = {},
}
