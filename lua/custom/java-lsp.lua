-- Java LSP configuration with debugging support
local M = {}

function M.setup()
  local jdtls = require 'jdtls'
  local home = os.getenv 'HOME'

  -- Determine the OS
  local system
  if vim.fn.has 'mac' == 1 then
    system = 'mac'
  elseif vim.fn.has 'unix' == 1 then
    system = 'linux'
  elseif vim.fn.has 'win32' == 1 then
    system = 'win'
  end

  -- Find jdtls installation (installed via Mason)
  local mason_registry = require 'mason-registry'
  local jdtls_path = mason_registry.get_package('jdtls'):get_install_path()

  -- Find the jar file
  local jar_patterns = {
    jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar',
  }
  local jar_file = nil
  for _, pattern in ipairs(jar_patterns) do
    local matches = vim.fn.glob(pattern, true, true)
    if #matches > 0 then
      jar_file = matches[1]
      break
    end
  end

  if not jar_file then
    vim.notify('Could not find jdtls jar file', vim.log.levels.ERROR)
    return
  end

  -- Configuration directory
  local config_path = jdtls_path .. '/config_' .. system

  -- Workspace directory (per project)
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

  -- Java debug adapter
  local bundles = {}
  local java_debug_path = mason_registry.get_package('java-debug-adapter'):get_install_path()
  local java_debug_jar = vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar')
  if java_debug_jar ~= '' then
    table.insert(bundles, java_debug_jar)
  end

  -- Java test adapter
  local java_test_path = mason_registry.get_package('java-test'):get_install_path()
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar'), '\n'))

  -- LSP configuration
  local config = {
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xmx1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-jar',
      jar_file,
      '-configuration',
      config_path,
      '-data',
      workspace_dir,
    },

    root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = 'interactive',
          runtimes = {
            {
              name = 'JavaSE-21',
              path = home .. '/.sdkman/candidates/java/current',
            },
          },
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        format = {
          enabled = true,
        },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
        },
      },
      contentProvider = { preferred = 'fernflower' },
      extendedClientCapabilities = jdtls.extendedClientCapabilities,
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
    },

    flags = {
      allow_incremental_sync = true,
    },

    init_options = {
      bundles = bundles,
    },

    on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

      -- Java specific keymaps
      vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, { buffer = bufnr, desc = '[J]ava: [O]rganize imports' })
      vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, { buffer = bufnr, desc = '[J]ava: Extract [V]ariable' })
      vim.keymap.set('v', '<leader>jv', [[<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>]], { buffer = bufnr, desc = '[J]ava: Extract [V]ariable' })
      vim.keymap.set('n', '<leader>jc', jdtls.extract_constant, { buffer = bufnr, desc = '[J]ava: Extract [C]onstant' })
      vim.keymap.set('v', '<leader>jc', [[<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>]], { buffer = bufnr, desc = '[J]ava: Extract [C]onstant' })
      vim.keymap.set('v', '<leader>jm', [[<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>]], { buffer = bufnr, desc = '[J]ava: Extract [M]ethod' })

      -- Setup DAP
      jdtls.setup_dap { hotcodereplace = 'auto' }
      require('jdtls.dap').setup_dap_main_class_configs()
    end,
  }

  -- Start or attach to jdtls
  jdtls.start_or_attach(config)
end

return M
