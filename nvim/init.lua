require('base')
require('highlight')
require('keymaps')
require('plugins')

local has = vim.fn.has
local is_macos = has "macunix"
local is_win = has "win32"

if is_macos then
  require("macos")
end
if is_win then
  require("windows")
end
