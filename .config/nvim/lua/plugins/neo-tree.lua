return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
      { "\\\\", "<cmd>Neotree filesystem toggle<cr>", desc = "Explorer (filesystem)" },
      { "\\\\b", "<cmd>Neotree buffers toggle<cr>", desc = "Explorer (buffers)" },
      { "\\\\g", "<cmd>Neotree git_status toggle<cr>", desc = "Explorer (git status)" },
    },
  }
}
