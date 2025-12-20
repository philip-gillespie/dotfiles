-- lsp.lua
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx) end
vim.lsp.handlers["window/logMessage"] = function(_, _) end

-- Disable virtual text and enable signs
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	severity_sort = true,
	update_in_insert = false,
})

-- Define custom signs for diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- plugins for langauage server protocol
return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyrefly", "ruff"},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument = capabilities.textDocument or {}
			capabilities.textDocument.synchronization = {
				dynamicRegistration = false,
				willSave = false,
				didSave = true,
				willSaveWaitUntil = false,
				change = 1, -- Full document sync instead of incremental DID NOT WORK
			}
		end,
	},
	-- none-ls.lua
	-- None ls is used for formatting and linting of files
	-- None-ls is a maintained fork of depractaed null os
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				-- ensure_installed = { "stylua", "prettier", "black", "isort" },
				ensure_installed = { "stylua", "prettier", "isort" },
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				debug = true,
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.prettier.with({
						extra_filetypes = { "toml" },
					}),
				},
			})
		end,
	},
}
