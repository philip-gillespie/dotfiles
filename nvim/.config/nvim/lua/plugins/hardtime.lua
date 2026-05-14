-- hardtime.lua
-- Encouraging better use of keystrokes by blocking multiple presses.
return {
	"m4xshen/hardtime.nvim",
	lazy = false,
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = { timeout = 5000, disable_mouse = false },
}
