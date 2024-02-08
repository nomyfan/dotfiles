local ok, gl = pcall(require, "gitlinker")
if not ok then return end

gl.setup {
  opts = {
    print_url = false,
  },
  mappings = nil,
}
