local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local events = require("luasnip.util.events")

local M = {}


---@class ActionSnippetContext
---@field trig string Text used to trigger the snippet
---@field name? string Short name shown in completion menu
---@field dscr? string Description shown in documentation

---Create a snippet that performs an action without inserting text.
---
---The action runs only after the snippet has been expanded. This avoids
---executing side effects when a completion engine inspects the snippet.
---
---@param context ActionSnippetContext 
---@param action fun() Function to run after expansion
---@return table snippet LuaSnip snippet
function M.action_snippet(context, action)
	return s(context, t(""), {
		-- -1 refers to the snippet itself rather than one of its nodes.
		callbacks = { [-1] = { [events.pre_expand] = action } },
	})
end

--- Check whether any of the lines matches the pattern.
--- @param lines string[]
--- @param pattern string
--- @return boolean # true if any line matches the pattern, false otherwise
function M.lines_contain_pattern(lines, pattern)
	for _, line in ipairs(lines) do
		if line:match(pattern) then
			return true
		end
	end
	return false
end

--- Find the last line that matches any of the patterns
--- @param lines string[]
--- @param patterns string[]
--- @return integer # line number of the last matching line, or 0 if none match
function M.find_last_matching_line(lines, patterns)
	local last_match = 0
	for index, line in ipairs(lines) do
		for _, pattern in ipairs(patterns) do
			if line:match(pattern) then
				last_match = index
			end
		end
	end
	return last_match
end

return M
