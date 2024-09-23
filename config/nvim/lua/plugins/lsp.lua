return {
	{
 		"nvim-telescope/telescope.nvim", -- optional
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
	},
  {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = true
},
{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
			servers = {
				pylance = {
					settings = {
						python = {
							analysis = {
								diagnosticMode = "openFilesOnly",
								-- include = { "workspaceroot/**" },
								-- extraPaths = { vim.fn.getcwd() },
								inlayHints = {
									variableTypes = true,
									functionReturnTypes = true,
									callArgumentNames = true,
									pytestParameters = true,
								},
							},
						},
					},
				},
				lua_ls = {},
				clangd = {},
				tsserver = {},
			},
		},
	},
	{
		"hinell/lsp-timeout.nvim",
		event = "LazyFile",
		dependencies = { "neovim/nvim-lspconfig" },
    config = true
	},
}
