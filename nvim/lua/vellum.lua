local M = {}

local palettes = {
  dark = {
    -- UI Colors
    bg           = "#262321", -- editor.background
    bg_alt       = "#211F1D", -- sideBar.background / tab.inactiveBackground
    bg_float     = "#2C2926", -- editorWidget.background / statusBar.background
    bg_highlight = "#302D2A", -- editor.lineHighlightBackground
    bg_visual    = "#453F39", -- editor.selectionBackground
    border       = "#36322E", -- editorWidget.border

    fg           = "#D8D3CB", -- editor.foreground
    fg_alt       = "#7C7670", -- comment / tab.inactiveForeground
    fg_gutter    = "#5C5650", -- editorLineNumber.foreground

    -- Syntax Colors
    keyword      = "#E6A67E", -- keywords, storage, markup.heading
    func         = "#DBBC7F", -- functions, methods
    type         = "#8FA895", -- classes, types, namespaces
    string       = "#A6C485", -- strings
    constant     = "#D699B6", -- numbers, booleans, constants
    error        = "#E68585", -- deleted, tags, errors
    punctuation  = "#9D9790", -- punctuation, braces
  },
  light = {
    -- UI Colors
    bg           = "#FAF8F5",
    bg_alt       = "#F2EFEC",
    bg_float     = "#EBE5DE",
    bg_highlight = "#F0EBE4",
    bg_visual    = "#E0D6CC",
    border       = "#B8B2AA",

    fg           = "#45413D",
    fg_alt       = "#9E978E",
    fg_gutter    = "#B8B2AA",

    -- Syntax Colors
    keyword      = "#C97034",
    func         = "#B38F2F",
    type         = "#4F6E5B",
    string       = "#5F8C48",
    constant     = "#9E658E",
    error        = "#C45C5C",
    punctuation  = "#8F8880",
  }
}

function M.setup()
  -- Reset syntax and highlights
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "vellum"

  -- Automatically choose palette based on background
  local is_dark = vim.o.background == "dark"
  local c = is_dark and palettes.dark or palettes.light

  local groups = {
    -- Base UI Highlight Groups
    Normal         = { fg = c.fg, bg = c.bg },
    NormalFloat    = { fg = c.fg, bg = c.bg_float },
    FloatBorder    = { fg = c.border, bg = c.bg_float },
    Cursor         = { fg = c.bg, bg = c.keyword },
    CursorLine     = { bg = c.bg_highlight },
    CursorColumn   = { bg = c.bg_highlight },
    CursorLineNr   = { fg = c.fg, bold = true },
    LineNr         = { fg = c.fg_gutter },
    SignColumn     = { bg = c.bg },
    ColorColumn    = { bg = c.bg_alt },
    Visual         = { bg = c.bg_visual },
    Search         = { fg = c.bg, bg = c.keyword },
    IncSearch      = { fg = c.bg, bg = c.keyword },
    MatchParen     = { fg = c.keyword, bold = true },
    Directory      = { fg = c.func },

    -- StatusLine & TabLine
    StatusLine     = { fg = c.fg, bg = c.bg_float },
    StatusLineNC   = { fg = c.fg_alt, bg = c.bg_alt },
    TabLine        = { fg = c.fg_alt, bg = c.bg_alt },
    TabLineFill    = { bg = c.bg_alt },
    TabLineSel     = { fg = c.keyword, bg = c.bg, bold = true },
    WinSeparator   = { fg = c.border },
    VertSplit      = { fg = c.border },

    -- Popup Menu (Completion)
    Pmenu          = { fg = c.fg, bg = c.bg_float },
    PmenuSel       = { fg = c.fg, bg = c.bg_visual },
    PmenuSbar      = { bg = c.bg_float },
    PmenuThumb     = { bg = c.fg_gutter },

    -- Standard Syntax Highlighting
    Comment        = { fg = c.fg_alt, italic = true },
    String         = { fg = c.string },
    Number         = { fg = c.constant },
    Boolean        = { fg = c.constant },
    Float          = { fg = c.constant },
    Constant       = { fg = c.constant },
    Character      = { fg = c.constant },
    Identifier     = { fg = c.fg },
    Function       = { fg = c.func },
    Statement      = { fg = c.keyword },
    Conditional    = { fg = c.keyword },
    Repeat         = { fg = c.keyword },
    Label          = { fg = c.keyword },
    Operator       = { fg = c.punctuation },
    Keyword        = { fg = c.keyword },
    Exception      = { fg = c.error },
    PreProc        = { fg = c.keyword },
    Include        = { fg = c.keyword },
    Define         = { fg = c.keyword },
    Macro          = { fg = c.func },
    Type           = { fg = c.type },
    StorageClass   = { fg = c.keyword },
    Structure      = { fg = c.type },
    Typedef        = { fg = c.type },
    Special        = { fg = c.punctuation },
    Tag            = { fg = c.error },
    Delimiter      = { fg = c.punctuation },
    Error          = { fg = c.error },
    Todo           = { fg = c.bg, bg = c.keyword, bold = true },

    -- Treesitter Highlighting
    ["@variable"]            = { fg = c.fg },
    ["@variable.builtin"]    = { fg = c.keyword },
    ["@variable.parameter"]  = { fg = c.fg },
    ["@variable.member"]     = { fg = c.fg },
    ["@function"]            = { fg = c.func },
    ["@function.builtin"]    = { fg = c.func },
    ["@function.macro"]      = { fg = c.func },
    ["@keyword"]             = { fg = c.keyword },
    ["@type"]                = { fg = c.type },
    ["@type.builtin"]        = { fg = c.type },
    ["@string"]              = { fg = c.string },
    ["@number"]              = { fg = c.constant },
    ["@boolean"]             = { fg = c.constant },
    ["@property"]            = { fg = c.fg },
    ["@tag"]                 = { fg = c.error },
    ["@tag.attribute"]       = { fg = c.type },
    ["@punctuation.delimiter"] = { fg = c.punctuation },
    ["@punctuation.bracket"] = { fg = c.punctuation },
    ["@module"]              = { fg = c.type },
    ["@constructor"]         = { fg = c.type },

    -- LSP Diagnostics
    DiagnosticError          = { fg = c.error },
    DiagnosticWarn           = { fg = c.keyword },
    DiagnosticInfo           = { fg = c.func },
    DiagnosticHint           = { fg = c.type },
    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.keyword, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = c.func, undercurl = true },
    DiagnosticUnderlineHint  = { sp = c.type, undercurl = true },

    -- GitSigns / Diff Colors
    GitSignsAdd              = { fg = c.string },
    GitSignsChange           = { fg = c.func },
    GitSignsDelete           = { fg = c.error },
    DiffAdd                  = { fg = c.string, bg = c.bg_highlight },
    DiffChange               = { fg = c.func, bg = c.bg_highlight },
    DiffDelete               = { fg = c.error, bg = c.bg_highlight },
    DiffText                 = { fg = c.fg, bg = c.bg_visual },
  }

  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

function M.lualine_theme()
  local is_dark = vim.o.background == "dark"
  local c = is_dark and palettes.dark or palettes.light

  return {
    normal = {
      a = { bg = c.keyword, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_visual, fg = c.fg },
      c = { bg = c.bg_float, fg = c.fg_alt },
    },
    insert = {
      a = { bg = c.string, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_visual, fg = c.fg },
      c = { bg = c.bg_float, fg = c.fg_alt },
    },
    visual = {
      a = { bg = c.constant, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_visual, fg = c.fg },
      c = { bg = c.bg_float, fg = c.fg_alt },
    },
    replace = {
      a = { bg = c.error, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_visual, fg = c.fg },
      c = { bg = c.bg_float, fg = c.fg_alt },
    },
    command = {
      a = { bg = c.func, fg = c.bg, gui = "bold" },
      b = { bg = c.bg_visual, fg = c.fg },
      c = { bg = c.bg_float, fg = c.fg_alt },
    },
    inactive = {
      a = { bg = c.bg_alt, fg = c.fg_alt, gui = "bold" },
      b = { bg = c.bg_alt, fg = c.fg_alt },
      c = { bg = c.bg_alt, fg = c.fg_alt },
    },
  }
end

return M
