-- breadcrumbs.lua
-- configuration for breadcrumbs in the editor

return {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
        require("nvim-navic").setup({
            highlight = true,
            separator = " > ",
            depth_limit = 5,
        })
    end,
}
