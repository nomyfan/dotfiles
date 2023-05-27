require('base')
require('highlight')
require('keymaps')
require('plugins')

shared = require('shared')

if shared.is_macos() then
  require("macos")
end
if shared.is_win() then
  require("windows")
end
