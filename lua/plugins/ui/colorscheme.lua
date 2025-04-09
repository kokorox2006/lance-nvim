return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true, -- Enable transparent background
        term_colors = true,
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          telescope = true,
        },
        highlight_overrides = {
          mocha = function(colors)
            return {
              -- Remove window borders
              WinSeparator = { fg = "NONE", bg = "NONE" },
              -- Customize Nix syntax highlighting
              ["@keyword.nix"] = { fg = colors.pink },
              ["@function.nix"] = { fg = colors.blue },
              ["@string.nix"] = { fg = colors.teal },
              ["@comment.nix"] = { fg = colors.overlay0, style = { "italic" }},
            }
          end,
        },
      })
      
      -- Additional window-related settings
      vim.opt.fillchars = vim.opt.fillchars + "eob: "  -- Remove ~ at end of buffer
      vim.opt.winblend = 0                             -- Make floating windows opaque
      
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
