return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			numhl = true,
			attach_to_untracked = true,
		})
	end,
}
