-- options.lua

-- Font
vim.o.guifont = "Source Code Pro:h44"

-- Copy / Paste Behaviour
vim.opt.clipboard = "unnamedplus"
-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- GUI
vim.opt.cursorline = true -- highlight the current line
vim.opt.wrap = false -- display long lines as one long line

-- Cursor
vim.opt.guicursor =
	"n-v-c-sm:block,i-ci-ve:ver25-blinkon500-blinkoff500,r-cr-o:hor20,t:ver25-blinkon500-blinkoff500-TermCursor"

-- Line numbers
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}

local term_settings = vim.api.nvim_create_augroup("TerminalSettings", { clear = true })

-- Set numbers ON when leaving Terminal mode (Normal mode)
vim.api.nvim_create_autocmd("TermLeave", {
	group = term_settings,
	pattern = "term://*",
	callback = function()
		vim.opt_local.relativenumber = true
	end,
})

-- Set numbers OFF when entering Terminal mode (Insert/Input mode)
vim.api.nvim_create_autocmd("TermEnter", {
	group = term_settings,
	pattern = "term://*",
	callback = function()
		vim.opt_local.relativenumber = false
	end,
})

-- Ensure new terminals start without numbers (as they start in Terminal mode)
vim.api.nvim_create_autocmd("TermOpen", {
	group = term_settings,
	callback = function()
		vim.opt_local.relativenumber = false
	end,
})

-- Do not expand tabs into spaces
vim.o.expandtab = true
-- Tab width to 4 spaces
vim.o.tabstop = 4
-- Tabs take up 4 spaces
vim.o.shiftwidth = 4

-- Autoindent
vim.opt.smartindent = false
vim.opt.autoindent = false

-- prevent autocomment on next line
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
})

-- highlight feedback on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- highlight column 80
vim.opt.colorcolumn = "80"

-- Hide command line when not in use
vim.opt.cmdheight = 0

-- searching
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- scrolloff
vim.opt.scrolloff = 8

-- close windows with q
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = {
		"netrw",
		"Jaq",
		"qf",
		"git",
		"help",
		"man",
		"lspinfo",
		"oil",
		"spectre_panel",
		"lir",
		"DressingSelect",
		"tsplayground",
		"",
	},
	callback = function(event)
		vim.keymap.set("n", "q", "<cmd>close<cr>", {
			buffer = event.buf,
			silent = true,
			nowait = true,
		})
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "floating-terminal" },
	callback = function(event)
		vim.keymap.set("n", "q", function()
			vim.api.nvim_win_hide(0)
		end, {
			buffer = event.buf,
			silent = true,
			nowait = true,
		})
	end,
})
