return {
  'stevearc/conform.nvim',
  opts = {},
  config = {
    format_after_save = {},
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'black' },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      c = { 'clang-format' },
      json = { 'prettierd' },
      yaml = { 'yamlfix', 'prettierd', 'prettier', stop_after_first = true },
      xml = { 'xmlformatter' },
    },
    formatters = { clang_format = { prepend_args = { '--style=file', '--fallback-style=LLVM' } } },
  },
}
