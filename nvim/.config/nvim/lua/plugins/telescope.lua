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

			telescope.load_extension("file_browser")
			local fb_actions = telescope.extensions.file_browser.actions

			telescope.setup({
				defaults = {
					file_ignore_patterns = { ".git/" }, -- Always hide .git internals
					mappings = { ["n"] = { ["q"] = actions.close } },
				},
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
								["c"] = fb_actions.create,
								["r"] = fb_actions.rename,
								["m"] = fb_actions.move,
								["d"] = fb_actions.remove,
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
			vim.keymap.set("n", "<leader>t", ":Telescope file_browser initial_mode=normal hidden=false <CR>")
			vim.keymap.set("n", "<leader>T", ":Telescope file_browser initial_mode=normal hidden=true <CR>")

			local builtin = require("telescope.builtin")

			-- Unfiltered search: Includes gitignored and hidden files
			vim.keymap.set("n", "<leader>fF", function()
				builtin.find_files({
					no_ignore = true,
					hidden = true,
				})
			end, { desc = "Telescope find files (unfiltered)" })

			-- Load Extensions
			telescope.load_extension("ui-select")
		end,
	},
}
