local function show_recording()
	local recording = vim.fn.reg_recording()
	if recording ~= "" then
		return "Recording @" .. recording
	end
	return ""
end

local function format_branch(name)
	if #name < 10 then
		return name
	end
	local parts = vim.split(name, "/")
	local processed = {}
	for i, p in ipairs(parts) do
		if i == #parts then
			table.insert(processed, string.sub(p, 1, 4))
			break
		end
		table.insert(processed, string.sub(p, 1, 2))
	end
	return table.concat(processed, "/")
end

local filename_cfg = {
	"filename",
	symbols = {
		modified = "●",
		readonly = "",
		unnamed = "",
	},
}

local lualine_cfg = {
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{
				"branch",
				fmt = format_branch,
			},
		},
		lualine_c = { "diff" },
		lualine_x = { show_recording, "diagnostics" },
		lualine_y = { "location" },
		lualine_z = { filename_cfg },
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
	options = {
		icons_enabled = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup(lualine_cfg)
	end,
}
