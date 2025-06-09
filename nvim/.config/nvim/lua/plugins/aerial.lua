-- aerial.lua
-- This allows <leader>a to show contents.
local function setup()
    require("aerial").setup({
        backends = { "treesitter" },
        -- filter_kind = false,
        close_on_select = true,
        layout = { min_width = 20, default_direction = "float" },
        float = { relative = "editor" },
        nav = { preview = true, max_width = 0.2 },
        manage_folds=true,
    })
    -- You probably also want to set a keymap to toggle aerial
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>")
end

return {
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = setup,
}
