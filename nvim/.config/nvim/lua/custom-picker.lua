local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function my_action(prompt_buffnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_buffnr)
		local selection = action_state.get_selected_entry()
		vim.api.nvim_put({ selection.value }, "c", false, true)
	end)
	return true
end

local function toy_color_picker(opts)
	opts = opts or {}

	pickers
		.new(opts, {
			prompt_title = "Toy Color Picker",
			finder = finders.new_table({ results = { "Red", "Green", "Blue", "Cyan", "Magenta" } }),
			sorter = conf.generic_sorter(opts),
			attach_mappings = my_action,
		})
		:find()
end

vim.api.nvim_create_user_command("ColorPicker", function()
	toy_color_picker({})
end, { desc = "Launch the Telescope toy color picker" })


