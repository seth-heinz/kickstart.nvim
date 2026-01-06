return {
  -- Groovy LSP support
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- Add groovy language server if not already present
      opts.servers = opts.servers or {}
      opts.servers.groovyls = {
        cmd = { 'groovy-language-server' },
        filetypes = { 'groovy' },
        root_dir = require('lspconfig.util').root_pattern('settings.gradle', 'build.gradle', '.git'),
      }
      return opts
    end,
  },

  -- Treesitter for Groovy syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'groovy' })
      end
    end,
  },
}
