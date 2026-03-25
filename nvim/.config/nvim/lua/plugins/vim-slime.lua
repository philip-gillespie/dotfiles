return {
	"jpalardy/vim-slime",

	-- The 'init' function runs BEFORE the plugin is loaded.
	-- This is required for vim-slime because it reads these global (vim.g)
	-- variables during its startup process.
	init = function()
		-- 1. Set target to tmux
		vim.g.slime_target = "wezterm"

		-- 2. Ensure IPython handles standard Python indentation correctly
		vim.g.slime_python_ipython = 1

		-- 3. Define what a "cell" looks like for your workflow
		vim.g.slime_cell_delimiter = "# %%"

		-- vim.g.slime_dont_ask_default = 1
	end,

	-- The 'config' function runs AFTER the plugin is loaded.
	-- This is where we set up our custom keybindings.
	config = function()
		-- Map <leader>c to send the current # %% cell to IPython
		-- vim.keymap.set("n", "<leader>c", "<Plug>SlimeSendCell", { desc = "Send cell to IPython" })
	end,
}
