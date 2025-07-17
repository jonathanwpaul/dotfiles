return {
  'shortcuts/no-neck-pain.nvim',
  config = function()
    require('no-neck-pain').setup {
      width = 120,
      buffers = {
        blend = -0.1,
        scratchPad = {
          enabled = true,
          fileName = 'clipboard.txt',
          location = '~/',
        },
        bo = {
          filetype = 'md',
        },
      },
    }
  end,
}
