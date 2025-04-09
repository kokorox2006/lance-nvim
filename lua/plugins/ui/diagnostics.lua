return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      use_diagnostic_signs = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
    },
    config = function()
      -- Set diagnostic signs
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Customize diagnostic colors
      vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff6c6c", bold = true })
      vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ffb86c", bold = true })
      vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#4ec9b0", bold = true })
      vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#56b6c2", bold = true })

      -- Virtual text colors
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff6c6c", bg = "#3c1818" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ffb86c", bg = "#3c2818" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#4ec9b0", bg = "#183c32" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#56b6c2", bg = "#183c3c" })

      -- Underline colors
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#ff6c6c", undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = "#ffb86c", undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = "#4ec9b0", undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#56b6c2", undercurl = true })
    end,
  },
}
