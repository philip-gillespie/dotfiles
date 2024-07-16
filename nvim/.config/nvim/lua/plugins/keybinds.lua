-- Toggle Code Diagnostics
local diagnostics_active = true

local function toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end
-- keybinds.lua
vim.g.mapleader = " " -- Set Leader Keybind
-- Plugin Keybindings
local keybinds = {
    ["<leader>"] = {
        b = {
            name = "Buffers",
            n = { "<cmd>bn<cr>", "Next" },
            p = { "<cmd>bp<cr>", "Previous" },
            x = { "<cmd>bd<cr>", "Delete" },
        },
        e = {
            name = "Diagnostic",
            t = {
                function()
                    toggle_diagnostics()
                end,
                "Toggle",
            },
            i = { "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>", "Info" },
            n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next" },
            p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous" },
        },
        f = {
            name = "File", -- typically using the plugin Telescope
            f = { "<cmd>Telescope find_files<cr>", "Find File" },
            g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
            h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
        },
        g = {
            name = "LSP",
            f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format File" },
            d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Get Definition" },
        },
        t = {
            "<cmd>Neotree filesystem reveal left toggle<cr>",
            "File Tree",
        },
        c = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment" },
    },
    ["<leader>/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment", mode = "v" },
    ["K"] = {
        "<cmd>lua vim.lsp.buf.hover()<cr>",
    },
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
        wk.register(keybinds)
    end,
}
