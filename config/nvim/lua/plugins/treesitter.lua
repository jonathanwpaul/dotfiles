return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
      auto_install = true,
      ensure_installed = { "c", "javascript", "python","lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
			highlight = {
				enable = true,
				use_languagetree = true,
			},
		},
	},
}
