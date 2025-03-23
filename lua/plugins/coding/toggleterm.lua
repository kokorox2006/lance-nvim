return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return vim.fn.floor(vim.o.lines * 0.3) -- 30% for horizontal
        elseif term.direction == 'vertical' then
          return vim.fn.floor(vim.o.columns * 0.3) -- 30% for vertical
        end
      end,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'vertical',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'rounded',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    }

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }

    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    vim.api.nvim_set_keymap(
      'n',
      '<leader>lg',
      '<cmd>lua _LAZYGIT_TOGGLE()<CR>',
      { noremap = true, silent = true }
    )
  end,
}
