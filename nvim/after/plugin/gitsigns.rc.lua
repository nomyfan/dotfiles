local loaded, gs = pcall(require, "gitsigns")
if (not loaded) then return end

gs.setup({
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.noremap = true
      opts.silent = true
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<LEADER>gp', gs.preview_hunk)
    map('n', '<LEADER>gs', gs.stage_hunk)
    map('n', '<LEADER>gu', gs.undo_stage_hunk)
    map('n', '<LEADER>gr', gs.reset_hunk)
    map('n', '<LEADER>gS', gs.stage_buffer)
    map('n', '<LEADER>gR', gs.reset_buffer)
    map('n', '<LEADER>gb', function() gs.blame_line({full=true}) end) 
    map('n', '<LEADER>tb', gs.toggle_current_line_blame)
    map('n', '<LEADER>gd', gs.diffthis)
    map('n', '<LEADER>gD', function() gs.diffthis('~') end)
    map('n', '<LEADER>td', gs.toggle_deleted)
  end
})
