local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("defn", {
    t("def "), i(1, "function_name"), t("("), i(2, "args"), t({ "):", "    " }),
    i(3, "pass")
  }),
}

