-- Easily comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  keys = {
    { '<C-/>', mode = { 'n', 'v' } },
    { '<C-_>', mode = { 'n', 'v' } },
  },
  config = function()
    require('Comment').setup()

    local api = require('Comment.api')

    local toggle_v = '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>'

    vim.keymap.set('n', '<C-/>', api.toggle.linewise.current, { noremap = true, silent = true })
    vim.keymap.set('n', '<C-_>', api.toggle.linewise.current, { noremap = true, silent = true })
    vim.keymap.set('v', '<C-/>', toggle_v, { noremap = true, silent = true })
    vim.keymap.set('v', '<C-_>', toggle_v, { noremap = true, silent = true })
  end,
}
