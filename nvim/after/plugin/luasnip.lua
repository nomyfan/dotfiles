local ls = require("luasnip")

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
})

ls.filetype_extend("javascriptreact", {"html"})
ls.filetype_extend("typescriptreact", {"html"})

-- You can also use lazy loading so you only get in memory snippets of languages you use
require('luasnip.loaders.from_vscode').lazy_load()
