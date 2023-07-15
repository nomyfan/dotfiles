local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local protocol = require('vim.lsp.protocol')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
  vim.keymap.set('n', 'gre', vim.lsp.buf.references, { noremap = true, silent = true, buffer=bufnr })
end

protocol.CompletionItemKind = {
  '', -- Text
  '', -- Method
  '', -- Function
  '', -- Constructor
  '', -- Field
  '', -- Variable
  '', -- Class
  'ﰮ', -- Interface
  '', -- Module
  '', -- Property
  '', -- Unit
  '', -- Value
  '', -- Enum
  '', -- Keyword
  '﬌', -- Snippet
  '', -- Color
  '', -- File
  '', -- Reference
  '', -- Folder
  '', -- EnumMember
  '', -- Constant
  '', -- Struct
  '', -- Event
  'ﬦ', -- Operator
  '', -- TypeParameter
}

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- TypeScript
nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities
}

-- CSS modules
nvim_lsp.cssmodules_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- Tailwind CSS
nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- Rust
local has_rust_tools, rust_tools = pcall(require, 'rust-tools')
if has_rust_tools then
rust_tools.setup({
tools = { -- rust-tools options
    autoSetHints = true,
    inlay_hints = {
        show_parameter_hints = false,
        parameter_hints_prefix = "",
        other_hints_prefix = "",
    },
},

-- all the opts to send to nvim-lspconfig
-- these override the defaults set by rust-tools.nvim
-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        -- to enable rust-analyzer settings visit:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        ["rust-analyzer"] = {
            -- enable clippy on save
            checkOnSave = {
                command = "clippy"
            },
        }
    }
},
})
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, prefix = "●" },
  severity_sort = true,
})

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '●'
  },
  update_in_insert = true,
  float = {
    source = "always", -- Or "if_many"
  },
})
