return {
	{
		-- Displays builtin LSP snippets
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		-- Snippet Engine for neovim
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		-- Completion engine for neovim
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
			cmp.setup({
				formatting = {
					format = function(entry, vim_item)
						-- Truncate overly long detail (e.g., function signatures)
						local detail = entry.completion_item.detail
						if detail and #detail > 40 then
							vim_item.menu = detail:sub(1, 27) .. "..."
						else
							vim_item.menu = detail
						end

						return vim_item
					end,
				},
				-- preselect = cmp.PreselectMode.None,
				preselect = cmp.PreselectMode.Item,
				completion = {
					-- completeopt = "menu,menuone,noinsert,noselect",
					completeopt = "menu,menuone,noinsert",
					autocomplete = false,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered({ max_width = 30 }),
					documentation = cmp.config.window.bordered({ max_width = 30 }),
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = function(_)
						if cmp.visible() then
							cmp.select_next_item()
							-- else
							-- 	cmp.complete()
						end
					end,
					["<C-Space>"] = cmp.mapping(function()
						cmp.complete()
					end, { "i", "c" }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					-- manually trigger the menu to appear
					-- ["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-n>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-m>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
