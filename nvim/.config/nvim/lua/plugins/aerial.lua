-- aerial.lua
local function setup()
	require("aerial").setup({
		backends = { "treesitter" },
		filter_kind = false,
		close_on_select = true,
		layout = { min_width = 20, default_direction = "float", max_width = 0.8 },
		float = { relative = "editor" },
		nav = { preview = true, max_width = 0.2 },
		manage_folds = false,
		link_tree_to_folds = false,
		link_folds_to_tree = false,

		show_guides = true,
		post_jump_cmd = "normal! zt",
		on_first_symbols = function(_)
			require("aerial").tree_close_all()
		end,
	})
	vim.keymap.set("n", "<leader> ", "<cmd>AerialNavToggle<CR>")
    -- inside aerial.lua setup function
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "aerial", "aerial-nav" }, -- Added the hyphen
        callback = function()
            -- Schedule ensures this runs after Aerial's own window logic
            vim.schedule(function()
                vim.wo.number = true
                vim.wo.relativenumber = true
            end)
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
