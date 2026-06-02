-- telescope.lua
-- Telescope for fuzzy finding and searching
local M = {}

function M.configure_telescope()
	local telescope = require("telescope")
	telescope.load_extension("file_browser")
	telescope.load_extension("ui-select")
	telescope.load_extension("aerial")

	telescope.setup(M.build_telescope_setup())
	M.show_telescope_line_numbers()
end

function M.build_telescope_setup()
	local actions = require("telescope.actions")
	local picker_config = {
		buffers = {
			mappings = {
				n = { ["dd"] = require("telescope.actions").delete_buffer },
			},
		},
	}
	return {
		defaults = {
			file_ignore_patterns = { ".git/" }, -- Always hide .git internals
			mappings = {
				["n"] = {
					["<esc>"] = false,
					["q"] = actions.close,
				},
			},
			sorting_strategy = "ascending",
			layout_config = {
				prompt_position = "top",
			},
		},
		pickers = picker_config,
		extensions = M.build_telescope_extension_cfg(actions),
	}
end

function M.build_telescope_extension_cfg(actions)
	local fb_actions = require("telescope").extensions.file_browser.actions
	return {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
		file_browser = {
			hijack_netrw = true,
			grouped = true,
			files_first = false, -- Ensures 'grouped' takes precedence
			sort_by = "name",
			hidden = true,
			use_fd = true,
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
	}
end

function M.show_telescope_line_numbers()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "TelescopeResults",
		callback = function()
			vim.opt_local.number = true
			vim.opt_local.relativenumber = true
		end,
	})
end

local function find_unfiltered_files()
	local builtin = require("telescope.builtin")
	builtin.find_files({
		no_ignore = true,
		hidden = true,
	})
end

local function show_file_tree(hidden)
	local telescope = require("telescope")
	telescope.load_extension("file_browser")
	telescope.extensions.file_browser.file_browser({
		initial_mode = "normal",
		hidden = hidden,
	})
end

local function load_aerial()
	local telescope = require("telescope")
	telescope.load_extension("aerial")
	telescope.extensions.aerial.aerial({ winblend = 10, previewer = true, show_nesting = true })
end

local keybinds = {
	{ "<leader>fa", load_aerial, desc = "Aerial" },
	{
		"<leader>t",
		function()
			show_file_tree(false)
		end,
		desc = "File Tree",
	},
	{
		"<leader>T",
		function()
			show_file_tree(true)
		end,
		desc = "File Tree (unfiltered)",
	},
	{
		"<leader>fF",
		find_unfiltered_files,
		desc = "Find files (unfiltered)",
	},
	{
		"<leader>ff",
		function()
			local builtin = require("telescope.builtin")
			builtin.find_files()
		end,
		desc = "Find files",
	},
	{
		"<leader>fb",
		function()
			local builtin = require("telescope.builtin")
			builtin.buffers({ initial_mode = "normal" })
		end,
		desc = "Buffers",
	},
	{
		"<leader>fg",
		function()
			local builtin = require("telescope.builtin")
			builtin.live_grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>fh",
		function()
			local builtin = require("telescope.builtin")
			builtin.help_tags()
		end,
		desc = "Help Tags",
	},
	{
		"<leader>fy",
		function()
			local builtin = require("telescope.builtin")
			builtin.git_status({ initial_mode = "normal" })
		end,
	},
}

return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"stevearc/aerial.nvim",
	},
	config = M.configure_telescope,
	keys = keybinds,
}
