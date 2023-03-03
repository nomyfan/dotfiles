local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then return end

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup#open-for-directories-and-change-neovims-directory
local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

nvim_tree.setup {
  open_on_tab = false,
}

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
