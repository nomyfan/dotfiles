return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp'
  },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local on_attach = function(client, bufnr)
      local shared = require('shared')
      local nmap = shared.nmap
      local map = shared.map
      nmap(']e', function()
        vim.diagnostic.jump({ count = 1 })
      end)

      nmap('[e', function()
        vim.diagnostic.jump({ count = -1 })
      end)
      nmap(']E', function()
        vim.diagnostic.jump({
          severity = vim.diagnostic.severity.ERROR,
          count = 1,
        })
      end)

      nmap('[E', function()
        vim.diagnostic.jump({
          severity = vim.diagnostic.severity.ERROR,
          count = -1,
        })
      end)

      nmap('K', vim.lsp.buf.hover)
      nmap('gd', vim.lsp.buf.definition)
      nmap('grr', vim.lsp.buf.references, { noremap = true, silent = true, buffer = bufnr })
      nmap('gri', vim.lsp.buf.implementation)
      nmap('grn', vim.lsp.buf.rename)
      nmap('grt', vim.lsp.buf.type_definition)

      map({ 'n', 'v' }, '<Leader>ca', function()
        require('tiny-code-action').code_action()
      end, {})

      if client.supports_method('textDocument/inlayHint') or client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      nmap('<Leader>F', vim.lsp.buf.format, { silent = true })
      -- Format on save
      vim.api.nvim_create_user_command('W', function()
        vim.cmd('lua vim.lsp.buf.format()')
        vim.cmd('w')
      end, {})
    end

    -- Lua
    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          }
        }
      }
    })
    vim.lsp.enable('lua_ls')

    -- Python
    vim.lsp.config('pyright', {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('pyright')
    vim.lsp.config('ruff', {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('ruff')

    -- Oxlint
    vim.lsp.config('oxylint', {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable('oxylint')

    -- Rust
    vim.lsp.config('rust_analyzer', {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        -- to enable rust-analyzer settings visit:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        ['rust-analyzer'] = {
          -- enable clippy on save
          -- checkOnSave = {
          --   command = 'clippy'
          -- },
        }
      }
    })
    vim.lsp.enable('rust_analyzer')

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN]  = '',
          [vim.diagnostic.severity.HINT]  = '',
          [vim.diagnostic.severity.INFO]  = '',
        }
      },
      virtual_text = {
        prefix = '●'
      },
      update_in_insert = true,
      float = {
        border = 'rounded',
        source = 'if_many',
        max_width = 88,
      },
    })
    vim.keymap.set("n", "<leader>e", function()
      vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end, { desc = "Line diagnostics" })
  end
}
