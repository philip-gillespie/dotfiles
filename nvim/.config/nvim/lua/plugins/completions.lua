return {
	"saghen/blink.cmp",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_lua").lazy_load({
					paths = vim.fn.stdpath("config") .. "/lua/snippets",
				})
			end,
		},
	},
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		snippets = {
			preset = "luasnip",
		},
		keymap = {
			preset = "none",
			["<CR>"] = { "fallback" }, -- Enter always just does Enter
			-- Confirmation
			["<C-e>"] = { "accept", "fallback" },
			["<C-CR>"] = { "accept", "fallback" },
			-- Navigation
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			-- Snippet Jumping
			["<C-n>"] = { "snippet_forward", "fallback" },
			["<C-p>"] = { "snippet_backward", "fallback" },
			-- Choice Nodes
			["<C-h>"] = { "snippet_backward", "fallback" },
			["<C-l>"] = { "snippet_forward", "fallback" },
			-- Documentation
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			-- Toggle
			["<C-Space>"] = { "show", "hide", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 1000,
				update_delay_ms = 200,
			},
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 0 },
						{ "kind_icon" },
					},
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				snippets = {
					opts = { use_label_description = true },
				},
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
