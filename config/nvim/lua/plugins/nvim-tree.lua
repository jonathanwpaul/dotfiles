return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { '\\', ':NvimTreeOpen<CR>', desc = 'NvimTree reveal', silent = true },
  },
  opts = {
  },
}
