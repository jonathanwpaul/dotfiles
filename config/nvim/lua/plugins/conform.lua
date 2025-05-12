return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    }
  end,
}
