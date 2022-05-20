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
    map('n', '<LEADER>hp', gs.preview_hunk)
    map('n', '<LEADER>hs', gs.stage_hunk)
    map('n', '<LEADER>hu', gs.undo_stage_hunk)
    map('n', '<LEADER>hr', gs.reset_hunk)
    map('n', '<LEADER>hS', gs.stage_buffer)
    map('n', '<LEADER>hR', gs.reset_buffer)
    map('n', '<LEADER>hb', function() gs.blame_line({full=true}) end) 
    map('n', '<LEADER>tb', gs.toggle_current_line_blame)
    map('n', '<LEADER>hd', gs.diffthis)
    map('n', '<LEADER>hD', function() gs.diffthis('~') end)
    map('n', '<LEADER>td', gs.toggle_deleted)
  end
})
