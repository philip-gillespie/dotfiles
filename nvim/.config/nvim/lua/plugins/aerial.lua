-- aerial.lua
-- This allows <leader>a to show contents.
local function setup()
	require("aerial").setup({
		backends = { "treesitter" },
		-- filter_kind = false,
		close_on_select = true,
		layout = { min_width = 20, default_direction = "float" },
		float = { relative = "editor" },
		nav = { preview = true, max_width = 0.2 },
		manage_folds = true,
		show_guides = true,
        post_jump_cmd = "normal! zt",
	})
	-- You probably also want to set a keymap to toggle aerial
	vim.keymap.set("n", "<leader> ", "<cmd>AerialToggle<CR>")
	-- Add this inside your setup() function after require("aerial").setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "aerial",
		callback = function()
			vim.opt_local.number = true
			vim.opt_local.relativenumber = true
		end,
	})
end

return {
	"stevearc/aerial.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = setup,
}
