return {
  'Shatur/neovim-session-manager',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local manager = require('session_manager')
    local config = require('session_manager.config')

    manager.setup {
      autoload_mode = config.AutoloadMode.Disabled,
      autosave_last_session = false,
    }

    -- Save current session and exit nvim.
    vim.api.nvim_create_user_command('X', function()
      local i = 0
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_get_option_value('modified', { buf = buf }) then
            return
          end
      end
      require('session_manager').save_current_session()
      vim.cmd('qa')
    end, {})

    -- Save current session.
    vim.api.nvim_create_user_command('S', function()
      require('session_manager').save_current_session()
    end, {})

    -- Load session for current directory.
    vim.api.nvim_create_user_command('L', function()
      require('session_manager').load_current_dir_session()
    end, {})

    vim.api.nvim_create_autocmd({ 'VimEnter' }, { 
      nested = true,
      callback = function(data)
        local is_directory = vim.fn.isdirectory(data.file) == 1
        if is_directory then
          vim.cmd.cd(data.file)
        end

        local argc = vim.fn.argc()
        if argc == 1 and is_directory then
          -- Partially copy from session_manager.load_current_dir_session
          local cwd = vim.uv.cwd()
          if cwd then
            local session = require('session_manager.config').dir_to_session_filename(cwd)
            if session:exists() then
              require('session_manager').load_current_dir_session()
              return
            end
          end

          -- Fallback
          shared.with_module('nvim-tree.api', function(api)
            api.tree.open()
          end)
        end
    end
  })
  end
}
