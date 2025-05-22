local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
}
