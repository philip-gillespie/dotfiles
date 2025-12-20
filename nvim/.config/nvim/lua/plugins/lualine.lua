-- Custom function to get buffer names with full paths
local function get_full_buffer_paths()
	local buffers = vim.api.nvim_list_bufs()
	local buffer_names = {}

	for _, buf in ipairs(buffers) do
		-- Get the full path for the buffer
		local bufname = vim.fn.bufname(buf)
		if bufname ~= "" then
			-- Use the full path of the buffer
			table.insert(buffer_names, vim.fn.fnamemodify(bufname, ":p"))
		else
			table.insert(buffer_names, "[No Name]")
		end
	end

	-- Join all buffer names with separators
	return table.concat(buffer_names, "  ")
end

local function show_recording()
	local recording = vim.fn.reg_recording()
	if recording ~= "" then
		return "Recording @" .. recording
	end
	return ""
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { { "buffers", show_filename_only = true } },
				lualine_c = {},
				lualine_x = { show_recording },
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
			options = {
				icons_enabled = false,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
		})
	end,
}
