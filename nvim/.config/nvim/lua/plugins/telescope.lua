-- telescope.lua
-- Telescope for fuzzy finding and searching
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = telescope.extensions.file_browser.actions

			telescope.setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					file_browser = {
						hijack_netrw = true,
						hidden = true,
						mappings = {
							["n"] = { -- Normal mode overrides
								["h"] = fb_actions.goto_parent_dir,
								["l"] = actions.select_default,
							},
						},
					},
				},
			})

			-- Relative line numbers in Telescope results
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "TelescopeResults",
				callback = function()
					vim.opt_local.number = true
					vim.opt_local.relativenumber = true
				end,
			})

			-- Global Keymap for File Browser
			vim.keymap.set("n", "<leader>t", ":Telescope file_browser initial_mode=normal <CR>")

			-- Load Extensions
			telescope.load_extension("ui-select")
			telescope.load_extension("file_browser")
		end,
	},
}
