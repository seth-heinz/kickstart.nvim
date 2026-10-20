return {
  -- add dracula
  {
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Load before other plugins
    config = function()
      local dracula = require 'dracula'
      dracula.setup {
        colors = {
          bg = '#000000', -- Pure black background
          menu = '#0d0d0d', -- Very slightly lighter black for menus
          visual = '#44475a', -- Brighter visual selection (Dracula's default selection color)
          gutter_fg = '#1a1a1a', -- Slightly lighter for gutter
          comment = '#7a8ac4', -- Brighter comment color (lighter blue-purple)
        },
        overrides = {
          -- Side banners/columns
          SignColumn = { bg = '#0d0d0d' },
          LineNr = { bg = '#0d0d0d' },
          CursorLineNr = { bg = '#0d0d0d' },
          -- Status line
          StatusLine = { bg = '#0d0d0d' },
          StatusLineNC = { bg = '#0d0d0d' },
          -- Normal text background
          Normal = { bg = '#000000' },
          NormalFloat = { bg = '#0d0d0d' },
          -- Make comments brighter
          Comment = { fg = '#7a8ac4', italic = true },
          -- Match IntelliJ Dracula's Java fields, constants, and parameters.
          ['@lsp.type.property.java'] = { link = '@variable.member' },
          ['@lsp.typemod.property.static.java'] = { link = '@constant' },
          ['@lsp.type.parameter.java'] = { fg = '#f8f8f2', italic = true },
          ['@variable.parameter.java'] = { link = '@lsp.type.parameter.java' },
          ['@attribute.java'] = { fg = '#50fa7b', italic = true },
          ['@lsp.type.decorator.java'] = { link = '@attribute.java' },
          ['@type.builtin.java'] = { link = '@keyword' },
          ['@keyword.return.java'] = { link = '@keyword' },
          ['@keyword.exception.java'] = { link = '@keyword' },
        },
      }
      vim.cmd.colorscheme 'dracula'
    end,
  },
}
