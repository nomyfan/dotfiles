local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup({
  ui = {
    devicon = true,
    code_action = "🚧",
  },
  lightbulb = {
    -- Showing in the status column will cause flickering.
    sign = false,
  },
})

