return {
	"yarospace/lua-console.nvim",
	lazy = true,
	keys = {
		{ "`", desc = "Lua-console - toggle" },
		-- { "<Leader>`", desc = "Lua-console - attach to buffer" },
	},
	opts = {
		buffer = {
			load_on_start = false,
			preserve_context = true,
			clear_before_eval = true,
		},
		window = { height = 0.4 },
	},
}
