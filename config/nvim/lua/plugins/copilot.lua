return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = function()
      local user = vim.env.USER or 'User'
      vim.keymap.set('n', '<leader>ai', '<cmd>CopilotChat<CR>', { desc = 'Copilot Chat' })
      return {
        auto_insert_mode = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.4,
        },
        -- keymaps = {
        --   accept = '<C-CR>',
        --   accept_word = '<C-CR>',
        --   accept_line = '<C-CR>',
        --   accept_word_fallback = '<C-CR>',
        --   accept_line_fallback = '<C-CR>',
        --   next = '<C-j>',
        --   prev = '<C-k>',
        --   close = '<C-e>',
        -- },
      }
    end,

    model = 'claude-3.7-sonnet',
  },
}
