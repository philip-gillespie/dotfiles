return {
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup()
		end,
	},
}
