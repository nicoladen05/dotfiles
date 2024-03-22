local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
  },
})
