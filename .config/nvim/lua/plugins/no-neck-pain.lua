return {
  'shortcuts/no-neck-pain.nvim',
  config = function()
    require('no-neck-pain').setup {
      width = 120,
      buffers = {
        right = {
          enabled = false
        },
        colors = {
          blend = -0.1,
        },
        wo = {
          fillchars = "eob: ",
        }
      },
      mappings = {
        enabled = true,
      },
    }
  end,
}
