local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local c = ls.choice_node
local r = ls.restore_node

function lua_repl_line(jump_index, depth, max_depth)
	depth = depth or 1
	max_depth = max_depth or 20

	if depth > max_depth then
		return t("")
	end

	return c(jump_index, {
		t(""), -- Option 1: Stop
		sn(nil, { -- Option 2: New Line
			t({ "", "> " }),
			r(1, "in_" .. depth, i(1)),
			t(" --> "),
			r(2, "out_" .. depth, i(1)),
			-- This dynamic node is jump index 3 within THIS line
			d(3, function()
				-- Inside the sn returned here, the choice_node
				-- is the first/only item, so it MUST be jump index 1
				return sn(nil, { lua_repl_line(1, depth + 1, max_depth) })
			end, {}),
		}),
	})
end

return {
	s("---", {
		t({ "---", "id: " }),
		i(1),
		t({ "", "aliases : [" }),
		i(2),
		t({ "]", "tags :", "\t-" }),
		i(3),
		t({ "", "---", "" }),
		i(4),
	}),
	s("file", {
		t("> [!file]"),
		i(1),
		t({ "", "> ```" }),
		i(2),
		t({ "", "> " }),
		i(3),
		t({ "", "> ```" }),
		i(4),
	}),
	s("\\n> ", { t({ "", "> " }) }),
	s("example", {
		t("> [!example] "),
		i(1),
		t({ "", "> ```" }),
		i(2),
		t({ "", "> " }),
		i(3),
		t({ "", "> ```" }),
		i(4),
	}),
	s("$$", { t({ "$$", "" }), i(1), t({ "", "$$" }) }),
	s("matrix", { t("\\begin{pmatrix}"), i(1), t("\\end{pmatrix}") }),
	s({ trig = "\\lua", dscr = "lua code block" }, {
		t({ "```lua", "" }),
		i(1),
		t({ "", "```" }),
	}),
	s({ trig = "\\luarepl" }, {
		t({ "```lua", "> " }),
		i(1),
		t({ " --> " }),
		i(2),
		lua_repl_line(3),
		t({ "", "```" }),
	}),
}
