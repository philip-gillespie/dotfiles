-- Toggle Code Diagnostics
local repl = require("repl")

local diagnostics_active = true

local function toggle_diagnostics()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

local function toggle_wrap()
	local wo = vim.wo
	wo.wrap = not wo.wrap

	if wo.wrap then
		vim.opt.linebreak = true
		vim.opt.breakindent = true
	else
		vim.opt.linebreak = false
		vim.opt.breakindent = false
	end
end

-- keybinds.lua
vim.g.mapleader = " " -- Set Leader Keybind
-- Plugin Keybindings
local keybinds = {
	{ "<C-/>", "<Plug>(comment_toggle_linewise_current)", desc = "Comment" },
	{ "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>bn", "<cmd>bn<cr>", desc = "Next" },
	{ "<leader>bp", "<cmd>bp<cr>", desc = "Previous" },
	{ "<leader>bx", "<cmd>bd<cr>", desc = "Delete" },
	{ "<leader>e", group = "Diagnostic" },
	{ "<leader>ei", "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>", desc = "Info" },
	{ "<leader>en", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next" },
	{ "<leader>ep", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Previous" },
	{ "<leader>et", toggle_diagnostics, desc = "Toggle" },
	{ "<leader>f", group = "File" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
	{ "<leader>g", group = "LSP" },
	{ "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Get Definition" },
	{
		"<leader>gf",
		function()
			vim.lsp.buf.format({ timeout = 2000 })
		end,
		desc = "Format File",
	},
	{ "<leader>gr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename Symbol" },
	{ "<leader>t", "<cmd>Neotree toggle<cr>", desc = "File Tree" },
	{ "<leader>w", toggle_wrap, desc = "Toggle Wrap" },
	{ "K", desc = "<cmd>lua vim.lsp.buf.hover()<cr>" },
	{ "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment", mode = "v" },
	-- REPL
	{ "<leader>s", group = "REPL", mode = "nv" },
	{ "<leader>sh", repl.send_hello_world, desc = "Send Hello World", mode = "n" },
	{ "<leader>sb", repl.send_current_buffer, desc = "Send Current Buffer", mode = "n" },
	{ "<leader>sl", repl.send_currentLine, desc = "Send Current Line", mode = "n" },
	{ "<leader>sc", repl.send_code_block, desc = "Send Code Block", mode = "n" },
	{ "<leader>sn", repl.send_code_block_move_to_next, desc = "Send Code Block + Move To Next", mode = "n" },
	{
		"<leader>sv",
		repl.send_visual_lines,
		desc = "Send Visual Lines",
		mode = "nv",
	},
	-- Git
	{ "<leader>y", group = "Git", mode = "n" },
	{
		"<leader>yb",
		"<cmd>Gitsigns toggle_current_line_blame<CR>",
		desc = "Toggle Current Line Blame",
	},
	{ "<leader>yp", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview Hunk" },
	{ "<leader>ys", "<cmd>Gitsigns stage_hunk<CR>", desc = "Toggle Stage Hunk" },
	{ "<leader>yS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
	{ "<leader>yU", "<cmd>Gitsigns reset_buffer_index<CR>", desc = "Unstage Buffer" },
	{ "<leader>yn", "<cmd>Gitsigns next_hunk<CR>" },
	{ "<leader>yN", "<cmd>Gitsigns prev_hunk<CR>" },
	{ "<leader>yu", "<cmd>Gitsigns reset_hunk<CR>" },
	{ "<leader>yb", "<cmd>Gitsigns toggle_current_line_blame<CR>" },
	{ "<leader>yB", "<cmd>Gitsigns blame_line<CR>" },
}

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		local wk = require("which-key")
		wk.setup({})
		wk.add(keybinds)
	end,
}
