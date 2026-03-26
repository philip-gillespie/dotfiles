return {
	"jpalardy/vim-slime",

	-- The 'init' function runs BEFORE the plugin is loaded.
	-- This is required for vim-slime because it reads these global (vim.g)
	-- variables during its startup process.
	init = function()
		-- 1. Set target to tmux
		vim.g.slime_target = "wezterm"
        vim.g.slime_no_mappings = 1

		-- 2. Ensure IPython handles standard Python indentation correctly
		-- vim.g.slime_python_ipython = 1
		vim.g.slime_bracketed_paste = 1
		-- 3. Define what a "cell" looks like for your workflow
		vim.g.slime_cell_delimiter = "# %%"

		-- vim.g.slime_dont_ask_default = 1
	end,

	-- The 'config' function runs AFTER the plugin is loaded.
	-- This is where we set up our custom keybindings.
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>s", group = "Slime / Send" },
			{ "<leader>sc", "<Plug>SlimeSendCell", desc = "Send Cell to IPython", remap = true },
			{ "<leader>sp", "<Plug>SlimeParagraphSend", desc = "Send Paragraph", remap = true },
			{ "<leader>sl", "<Plug>SlimeLineSend", desc = "Send Line", remap = true },
			{ "<leader>sv", "<Plug>SlimeConfig", desc = "Configure Slime Pane", remap = true },

			-- Visual mode bindings (note the mode = "x")
			{ "<leader>s", "<Plug>SlimeRegionSend", desc = "Send Visual Selection", mode = "x", remap = true },
		})
	end,
}
