local M = {}

local gitsigns = {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			numhl = true,
			attach_to_untracked = true,
		})
	end,
}
table.insert(M, gitsigns)

local vim_fugitive = {
	"tpope/vim-fugitive",
	cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gwrite", "Gread", "Gbrowse" },
}
table.insert(M, vim_fugitive)

return M
