local config = require('session_manager.config')

require('session_manager').setup {
  autoload_mode = config.AutoloadMode.Disabled,
  autosave_last_session = false,
}
