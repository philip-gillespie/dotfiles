local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local c = ls.choice_node
local r = ls.restore_node


local function lua_repl_line(depth)
	if depth > 50 then
		return sn(nil, { t("") })
	end

	return sn(nil, {
		c(1, {
			t(""), -- Option 1: Stop (Default, prevents infinite loop)
			sn(nil, { -- Option 2: Input + Output
				t({ "", "" }),
				r(1, "in_" .. depth, i(1)),
				t(" --> "),
				r(2, "out_" .. depth, i(1)),
				d(3, function()
					return lua_repl_line(depth + 1)
				end, {}),
			}),
			sn(nil, { -- Option 3: Input only
				t({ "", "" }),
				r(1, "in_" .. depth, i(1)),
				d(2, function()
					return lua_repl_line(depth + 1)
				end, {}),
			}),
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
	s({ trig = "\\lua" }, {
		t("```lua"),
		c(1, {
			sn(nil, {
				t({ "", "" }),
				r(1, "in_0", i(1)),
				t(" --> "),
				r(2, "out_0", i(1)),
			}),
			sn(nil, {
				t({ "", "" }),
				r(1, "in_0", i(1)),
			}),
		}),
		d(2, function()
			return lua_repl_line(1)
		end, {}),
		t({ "", "```" }),
	}),
}
