return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp'
  },
  config = function()
    local protocol = require('vim.lsp.protocol')
    local lsp = require('lspconfig')
    local shared = require('shared')

    local on_attach = function(client, bufnr)
      local nmap = shared.nmap

      if client.supports_method('textDocument/inlayHint') or client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      nmap("<Leader>F", ":lua vim.lsp.buf.format()<CR>", { silent = true })
      -- Format on save
      vim.api.nvim_create_user_command('W', function()
        vim.cmd('lua vim.lsp.buf.format()')
        vim.cmd('w')
      end ,{})

      nmap('gre', vim.lsp.buf.references, { noremap = true, silent = true, buffer = bufnr })
    end
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Python
    lsp.pylsp.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    -- TypeScript
    lsp.tsserver.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx' },
      cmd = { 'typescript-language-server', '--stdio' },
      init_options = {
        preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          importModuleSpecifierPreference = 'non-relative',
        },
      },
    }

    -- CSS modules
    lsp.cssmodules_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    -- Tailwind CSS
    lsp.tailwindcss.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    -- ESLint
    lsp.eslint.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    -- Rust
    lsp.rust_analyzer.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        -- to enable rust-analyzer settings visit:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        ['rust-analyzer'] = {
          -- enable clippy on save
          checkOnSave = {
            command = 'clippy'
          },
        }
      }
    }

    -- Clangd
    lsp.clangd.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    -- PowerShell
    lsp.powershell_es.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      bundle_path = os.getenv('LSP_POWERSHELL_PATH')
    }

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = '●' },
      severity_sort = true,
    })


    -- Diagnostic symbols in the sign column (gutter)
    local signs = { Error = '', Warn = '', Hint = '', Info = '' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    vim.diagnostic.config {
      virtual_text = {
        prefix = '●'
      },
      update_in_insert = true,
      float = {
        source = 'always', -- Or 'if_many'
      },
    }
  end
}
