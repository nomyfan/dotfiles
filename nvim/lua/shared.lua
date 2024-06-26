local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.nmap(lhs, rhs, opts)
  M.map('n', lhs, rhs, opts)
end

function M.is_macos()
  return 1 == vim.fn.has "macunix"
end

function M.is_win()
  return 1 == vim.fn.has "win32"
end

-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
  local api = vim.api
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup '..group_name)
    api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      api.nvim_command(command)
    end
    api.nvim_command('augroup END')
  end
end

function M.with_module(module, callback)
  local ok, mod = pcall(require, module)
  if ok then
    callback(mod)
  end
end

function M.starts_with(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

return M
