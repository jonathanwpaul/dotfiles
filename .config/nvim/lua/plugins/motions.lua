return {
  {
    -- CAMEL CASE MOTION SUPPORT
    'bkad/CamelCaseMotion',
    keys = {
      {
        'w',
        '<Plug>CamelCaseMotion_w',
        mode = { 'n', 'o', 'v' },
        noremap = true,
        silent = true,
        -- move to the start of the next word
      },
      {
        'b',
        '<Plug>CamelCaseMotion_b',
        mode = { 'n', 'o', 'v' },
        noremap = true,
        silent = true,
        -- move to the start of the previous word
      },
      {
        'e',
        '<Plug>CamelCaseMotion_e',
        mode = { 'n', 'o', 'v' },
        noremap = true,
        silent = true,
        -- move to the end of the next word
      },
      {
        'ge',
        '<Plug>CamelCaseMotion_ge',
        mode = { 'n', 'o', 'v' },
        noremap = true,
        silent = true,
        -- move to the end of the previous word
      },
    },
  },
  {
    -- MOVE LINES AROUND
    'fedepujol/move.nvim',
    keys = {
      {
        '<M-j>',
        ':MoveLine(1)<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
      },
      {
        '<M-k>',
        ':MoveLine(-1)<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
      },
      {
        '<M-j>',
        ':MoveBlock(1)<CR>',
        mode = 'v',
        noremap = true,
        silent = true,
      },
      {
        '<M-k>',
        ':MoveBlock(-1)<CR>',
        mode = 'v',
        noremap = true,
        silent = true,
      },
    },
    config = true,
  },
}
