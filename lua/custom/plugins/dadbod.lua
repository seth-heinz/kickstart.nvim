return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
      { '<leader>db', '<cmd>DBUIToggle<CR>', desc = 'Database drawer' },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_save_location = vim.fn.expand '~/.local/share/db_ui'
      -- Homebrew's client-only formula is keg-only; leave the shell PATH unchanged.
      if vim.fn.executable 'mysql' == 0 and vim.fn.isdirectory '/opt/homebrew/opt/mysql-client@8.4/bin' == 1 then
        vim.env.PATH = '/opt/homebrew/opt/mysql-client@8.4/bin:' .. vim.env.PATH
      end
      if vim.fn.executable 'psql' == 0 and vim.fn.isdirectory '/opt/homebrew/opt/libpq/bin' == 1 then
        vim.env.PATH = '/opt/homebrew/opt/libpq/bin:' .. vim.env.PATH
      end
    end,
  },
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        per_filetype = {
          sql = { 'snippets', 'dadbod', 'buffer' },
          mysql = { 'snippets', 'dadbod', 'buffer' },
          plsql = { 'snippets', 'dadbod', 'buffer' },
        },
        providers = {
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
  },
}
