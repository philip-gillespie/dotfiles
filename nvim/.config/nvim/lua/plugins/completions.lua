local M = {}
-- Displays builtin LSP snippets
table.insert(M, { "hrsh7th/cmp-nvim-lsp" })

-- Snippet Engine for neovim
table.insert(M, {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"saadparwaiz1/cmp_luasnip",
	},
})
-- Dictionary completion source
table.insert(M, { "uga-rosa/cmp-dictionary" })

-- Completion engine for neovim

-- cmp config
local function format_suggestion(entry, vim_item)
	-- Truncate overly long detail (e.g., function signatures)
	local detail = entry.completion_item.detail
	if detail and #detail > 40 then
		vim_item.menu = detail:sub(1, 27) .. "..."
	else
		vim_item.menu = detail
	end

	return vim_item
end

local function expand_snippet(args)
	require("luasnip").lsp_expand(args.body)
end

local function filter_dictionary_words(entry, ctx)
	local word = entry:get_completion_item().label
	-- Get the length of the text before the cursor (what the user typed)
	local typed_length = string.len(ctx.cursor_before_line:match("(%S*)$") or "")
	-- Only suggest words that are at least 3 letters longer than what's typed
	return #word >= typed_length + 1 and #word >= 3
end

local function config()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local cfg = {
		formatting = { format = format_suggestion },
		preselect = cmp.PreselectMode.Item,
		completion = { completeopt = "menu,menuone,noinsert" },
		snippet = { expand = expand_snippet },
		window = { documentation = { max_width = 50 } },
	}
	-- Choice node navigation
	local function select_next_choice(fallback)
		if luasnip.choice_active() then
			luasnip.change_choice(1)
		else
			fallback()
		end
	end

	local function select_prev_choice(fallback)
		if luasnip.choice_active() then
			luasnip.change_choice(-1)
		else
			fallback()
		end
	end

	-- Mappings
	local keymaps = {}
	keymaps["<CR>"] = function(fallback)
		fallback()
	end
	keymaps["<C-h>"] = cmp.mapping(select_next_choice, { "i", "s" })
	keymaps["<C-l>"] = cmp.mapping(select_prev_choice, { "i", "s" })
	keymaps["<C-b>"] = cmp.mapping.scroll_docs(-4)
	keymaps["<C-f>"] = cmp.mapping.scroll_docs(4)
	keymaps["<C-e>"] = cmp.mapping.confirm({ select = false })
	keymaps["<C-CR>"] = cmp.mapping.confirm({ select = false })
	-- jump through snippet
	local function jump(fallback)
		if luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		end
	end
	keymaps["<C-n>"] = cmp.mapping(jump, { "i", "s" })
	local function jump_backward(fallback)
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end
	keymaps["<C-p>"] = cmp.mapping(jump_backward, { "i", "s" })
	-- Toggle suggestions
	local function toggle_suggestions()
		if cmp.visible() then
			cmp.close()
		else
			cmp.complete()
		end
	end
	keymaps["<C-Space>"] = toggle_suggestions
	-- Next suggestion
	local function next_suggestion(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		else
			fallback()
		end
	end
	keymaps["<C-j>"] = next_suggestion
	-- Previous suggestion
	local function prev_suggestion(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		else
			fallback()
		end
	end
	keymaps["<C-k>"] = prev_suggestion

	-- Use these specified keymaps
	cfg["mapping"] = cmp.mapping.preset.insert(keymaps)

	-- Sources for completion
	cfg["sources"] = cmp.config.sources({
		-- PRIMARY TIER - these sources are tried first
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "dictionary", entry_filter = filter_dictionary_words },
	})
	return cfg
end

local function setup_completions()
	local cmp = require("cmp")
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
	cmp.setup(config())
	require("cmp_dictionary").setup({
		paths = { "/usr/share/dict/words" },
		first_case_insensitive = true,
	})
end

table.insert(M, {
	"hrsh7th/nvim-cmp",
	config = setup_completions,
})

-- Toggle for autocompletions
local cmp_autocomplete_enabled = true
-- Toggle Autocomplete
function _G.ToggleCmpAutocomplete()
	cmp_autocomplete_enabled = not cmp_autocomplete_enabled
	require("cmp").setup({
		completion = {
			autocomplete = cmp_autocomplete_enabled and { require("cmp.types").cmp.TriggerEvent.TextChanged } or {},
		},
	})
	print("Autocomplete " .. (cmp_autocomplete_enabled and "enabled" or "disabled"))
end

-- Set as keymap
vim.keymap.set("n", "<leader>c", ToggleCmpAutocomplete, { desc = "Toggle completions" })

-- Return the module
return M
