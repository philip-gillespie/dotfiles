local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local events = require("luasnip.util.events")

local M = {}

---Create a snippet that performs an action without inserting text.
---
---The action runs only after the snippet has been expanded. This avoids
---executing side effects when a completion engine inspects the snippet.
---
---@param trigger string Text used to trigger the snippet
---@param action fun() Function to run after expansion
---@return table snippet LuaSnip snippet
function M.action_snippet(trigger, action)
	return s(trigger, t(""), {
		-- -1 refers to the snippet itself rather than one of its nodes.
		callbacks = { [-1] = { [events.pre_expand] = action } },
	})
end

return M
