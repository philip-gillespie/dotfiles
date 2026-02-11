local opts = {
	bar = { pick = { pivots = "1234567890-=" } },
	-- sources = { lsp = { fallback = true } },
}

local function configure_dropbar()
	require("dropbar").setup(opts)
	local dropbar = require("dropbar.api")
	vim.keymap.set("n", "<Leader>;", dropbar.pick, { desc = "Pick symbols in winbar" })
	vim.keymap.set("n", "[;", dropbar.goto_context_start, { desc = "Go to start of current context" })
	vim.keymap.set("n", "];", dropbar.select_next_context, { desc = "Select next context" })
end

return {
	"Bekaboo/dropbar.nvim",
	-- optional, but required for fuzzy finder support
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		"ibhagwan/fzf-lua", -- recommended
		build = "make",
	},
	config = configure_dropbar,
}
