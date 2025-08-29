return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 2500,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'yamlfix', 'prettierd', 'prettier', stop_after_first = true },
        xml = { 'xmlformatter' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
    }
  end,
}
