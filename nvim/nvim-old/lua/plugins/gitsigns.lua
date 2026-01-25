return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.noremap = true
          opts.silent = true
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
      -- Navigation
        map('n', ']c', "&diff ? ']c' : ':Gitsigns next_hunk<CR>'", {expr=true})
        map('n', '[c', "&diff ? '[c' : ':Gitsigns prev_hunk<CR>'", {expr=true})

        -- Actions
        map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>')
        map('n', '<leader>hR', ':Gitsigns reset_buffer<CR>')
        map('n', '<leader>hp', ':Gitsigns preview_hunk<CR>')
        map('n', '<leader>hb', ':lua require"gitsigns".blame_line{full=true}<CR>')
        map('n', '<leader>tb', ':Gitsigns toggle_current_line_blame<CR>')
        map('n', '<leader>hd', ':Gitsigns diffthis<CR>')
        map('n', '<leader>hD', ':lua require"gitsigns".diffthis("~")<CR>')
        map('n', '<leader>td', ':Gitsigns toggle_deleted<CR>')
      end
    }
  end
}
