-- options.lua

-- Font
vim.o.guifont = "Source Code Pro:h44"

-- GUI
vim.opt.cursorline = true -- highlight the current line
vim.opt.wrap = false -- display long lines as one long line
-- Line numbers
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}
-- Do not expand tabs into spaces
vim.o.expandtab = true
-- Tab width to 4 spaces
vim.o.tabstop = 4
-- Tabs take up 4 spaces
vim.o.shiftwidth = 4

-- Autoindent
vim.opt.smartindent = true
vim.opt.autoindent = true

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

-- scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

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
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
	end,
})
