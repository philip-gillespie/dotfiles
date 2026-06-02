-- lsp.lua

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

-- LSP Log Management
local lsp_log_path = vim.lsp.log.get_filename()
local max_size_mb = 5 -- Change this to your preferred limit (e.g., 5MB or 10MB)

local function clean_lsp_log()
	local f = io.open(lsp_log_path, "r")
	if f then
		local size = f:seek("end")
		f:close()
		-- Convert MB to bytes
		if size > (max_size_mb * 1024 * 1024) then
			os.remove(lsp_log_path)
			-- Optional: Notify you that it happened
			vim.notify("LSP log exceeded " .. max_size_mb .. "MB and was cleared.", vim.log.levels.INFO)
		end
	end
end

-- Run the check on startup
clean_lsp_log()

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
				ensure_installed = { "lua_ls", "pyrefly", "ruff" },
			})
		end,
	},
	{
		-- lazydev for developing neovim configs
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Loads luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			capabilities.textDocument = capabilities.textDocument or {}
			capabilities.textDocument.synchronization = {
				dynamicRegistration = false,
				willSave = false,
				didSave = true,
				willSaveWaitUntil = false,
			}

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("ruff", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ruff")

			vim.lsp.config("pyrefly", {
				cmd = { "sh", "-c", "exec pyrefly lsp 2>/dev/null" },
				capabilities = capabilities,
				settings = {
					python = {
						pyrefly = {
							displayTypeErrors = "force-on",
						},
					},
				},
			})
			vim.lsp.enable("pyrefly")
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
				ensure_installed = { "stylua", "prettier" },
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier.with({
						extra_filetypes = { "toml" },
					}),
				},
			})
		end,
	},
}
