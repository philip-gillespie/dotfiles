-- init.lua

-- Package Manager `Lazy`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")

-- Setup with plugins and options
require("options")
require("keybinds")
require("floating-terminal")
require("repl").setup()
-- Will source plugins from ~/.config/nvim/lua/plugins.lua
require("lazy").setup("plugins")
require("custom-picker")
