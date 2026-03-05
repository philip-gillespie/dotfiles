-- return {}
return {
	"echasnovski/mini.indentscope",
	version = false, -- wait for stable or use latest
	config = function()
		require("mini.indentscope").setup({
			-- The symbol used for the vertical line
			-- '│' is the standard, '▎' is a bit thinner/modern
			symbol = "▎",
			options = {
				try_as_border = true,
				border = "top",
				indent_at_cursor = true,
			},
			draw = {
				-- Delay (in ms) before showing the scope
				-- Setting this to 0 makes it feel much more responsive
				delay = 0,
				-- Animation duration (in ms)
				-- Set to 0 if you hate the "moving line" effect
				animation = require("mini.indentscope").gen_animation.none()
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
