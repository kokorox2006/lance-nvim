return {
  {
    "nvim-zh/colorful-winsep.nvim",
    enabled = false,  -- Disable any colorful window separators
  },
  {
    "lukas-reineke/virt-column.nvim",
    config = function()
      require("virt-column").setup()
      vim.cmd [[highlight WinSeparator guifg=#1a1b26 guibg=none]]  -- Make window separators blend with background
      vim.opt.fillchars = {
        horiz = "─",
        horizup = "┴",
        horizdown = "┬",
        vert = "│",
        vertleft = "┤",
        vertright = "├",
        verthoriz = "┼",
      }
      vim.opt.laststatus = 3  -- Global statusline
      vim.opt.winbar = nil    -- Disable winbar
    end
  }
}
