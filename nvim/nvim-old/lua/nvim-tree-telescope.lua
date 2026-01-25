-- @see https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#find-file-from-node-in-telescope
local api = require("nvim-tree.api")
local M = {}

function M.launch_live_grep(opts)
  return M.launch_telescope("live_grep", opts)
end

function M.launch_find_files(opts)
  return M.launch_telescope("find_files", opts)
end

function M.launch_telescope(func_name, opts)
  local telescope_status_ok, _ = pcall(require, "telescope")
  if not telescope_status_ok then
    return
  end

  local basedir = "."

  if opts ~= nil and opts.basedir ~= nil then
    basedir = opts.basedir
  elseif api.tree.is_visible() then
      local node = api.tree.get_node_under_cursor()
      if node == nil then
        if TreeExplorer ~= nil then
          basedir = TreeExplorer.cwd
        end
      else
        local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
        basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
        if (node.name == '..' and TreeExplorer ~= nil) then
          basedir = TreeExplorer.cwd
        end
      end
  end

  opts = opts or {}
  opts.cwd = basedir
  opts.search_dirs = { basedir }
  return require("telescope.builtin")[func_name](opts)
end

return M
