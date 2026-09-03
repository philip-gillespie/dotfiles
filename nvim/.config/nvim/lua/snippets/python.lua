local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

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
	"li",
	fmt('logger.info("{}")', {
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

return vim.tbl_values(completions)
