local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local helpers = require("snippets.helpers")

local completions = {}

completions.def = s(
	"def",
	fmt(
		[[
    def {}({}) -> {}:
        {}

    ]],
		{ i(1, "function"), i(2), i(3, "None"), i(4, "return None") }
	)
)

completions.main = s("main", t({ "def main() -> None:", "\treturn None", "" }))

completions.if_main = s(
	'if __name__ == "__main__"',
	t({
		'if __name__ == "__main__":',
		"\tmain()",
		'\tprint("All done!")',
	})
)

local PADDING_LENGTH = 80
local function pad_left(args)
	local title = args[1][1]
	local padding = PADDING_LENGTH - 2 - #title
	if padding < 0 then
		return "# "
	end
	local n_left = math.floor(padding / 2)
	return string.rep("#", n_left) .. " "
end
local function pad_right(args)
	local title = args[1][1]
	local padding = PADDING_LENGTH - 2 - #title
	if padding < 0 then
		return ""
	end
	local n_left = math.floor(padding / 2)
	local n_right = padding - n_left
	return " " .. string.rep("#", n_right)
end

completions.heading = s("#heading", {
	f(pad_left, 1),
	i(1),
	f(pad_right, 1),
})

-- -- print with f string
completions.printf = s(
	"printf",
	-- def {}({}) -> {}:
	fmt(
		[[
    print(f"{}{{{}}}{}")
    ]],
		{ i(1), i(2), i(3) }
	)
)

completions.log_info = s(
	{
		trig = "li",
		dscr = 'logger.info("")',
	},
	fmt('logger.info("{}")', {
		i(1),
	})
)

completions.log_info_fstring = s(
	"lif",
	fmt('logger.info(f"{}")', {
		i(1),
	})
)

completions.log_warning = s(
	"lw",
	fmt('logger.warning("{}")', {
		i(1),
	})
)

completions.log_error = s(
	"le",
	fmt('logger.error("{}")', {
		i(1),
	})
)

completions.log_debug = s(
	"ld",
	fmt('logger.debug("{}")', {
		i(1),
	})
)

local function add_logger()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local has_logging = helpers.lines_contain_pattern(lines, "import logging")
	local has_logger = helpers.lines_contain_pattern(lines, "logger = logging.getLogger(__name__)")
	local last_import_line = helpers.find_last_matching_line(lines, { "^import%s+", "^from%s.*import%s+" })
	local lines_added = 0
	if not has_logging then
		vim.api.nvim_buf_set_lines(0, 0, 0, false, { "import logging" })
		lines_added = lines_added + 1
		last_import_line = last_import_line + 1
	end
	if not has_logger then
		vim.api.nvim_buf_set_lines(0, last_import_line + 1, last_import_line + 1, false, {
			"logger = logging.getLogger(__name__)",
			"",
		})
		lines_added = lines_added + 2
	end
	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, { row + lines_added, col })
	end)
end

completions.logging_setup = helpers.action_snippet("il", add_logger)

local function add_dataclass_import()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	if helpers.lines_contain_pattern(lines, "^from dataclasses import dataclass") then
		return
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_buf_set_lines(0, 0, 0, false, { "from dataclasses import dataclass" })
	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, { row + 1, col })
	end)
end

completions.import_dataclass = helpers.action_snippet("id", add_dataclass_import)

return vim.tbl_values(completions)
