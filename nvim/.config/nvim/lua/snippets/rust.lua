local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Println
local println = s("println!", { t('println!("'), i(1), t('");') })
local let = s("let", { t("let "), i(1), t(" = "), i(2), t(";") })

return { println, let}
