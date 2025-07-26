return {
  'shortcuts/no-neck-pain.nvim',
  config = function()
    require('no-neck-pain').setup {
      width = 120,
      buffers = {
        colors = {
          blend = -0.1,
        },
        scratchPad = {
          enabled = true,
          fileName = 'clipboard',
          location = '~/',
        },
        bo = {
          filetype = 'md',
        },
      },
      mappings = {
        enabled = true,
      },
    }
  end,
}
