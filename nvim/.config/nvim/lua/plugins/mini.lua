return {
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"nvim-mini/mini.ai",
		version = "*",
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-mini/mini.bracketed",
		version = "*",
		config = function()
			require("mini.bracketed").setup()
		end,
	},
	{
		"nvim-mini/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},
}
