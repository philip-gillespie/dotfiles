local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local completions = {}

local def = s(
	"def",
	fmt(
		[[
    def {}({}) -> {}:
        {}

    ]],
		{ i(1, "function"), i(2), i(3, "None"), i(4, "return None") }
	)
)
table.insert(completions, def)

local main = s("main", t({ "def main() -> None:", "\treturn None", "" }))
table.insert(completions, main)

local if_main = s(
	'if __name__ == "__main__"',
	t({
		'if __name__ == "__main__":',
		"\tmain()",
		'\tprint("All done!")',
	})
)
table.insert(completions, if_main)

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

local heading = s("#heading", {
	f(pad_left, 1),
	i(1),
	f(pad_right, 1),
})
table.insert(completions, heading)

-- -- print with f string
local printf = s(
	"printf",
	-- def {}({}) -> {}:
	fmt(
		[[
    print(f"{}{{{}}}{}")
    ]],
		{ i(1), i(2), i(3) }
	)
)
table.insert(completions, printf)

return completions
