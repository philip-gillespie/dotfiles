-- neotree.lua
-- allows showing a filesystem tree
local function navigate_to(state)
    local node = state.tree:get_node()
    if node and node.type == "directory" then
        require("neo-tree.sources.filesystem").navigate(state, node:get_id())
    end
end
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            window = {
                mappings = { ["l"] = navigate_to, ["<Tab>"] = navigate_to },
                position = "float",
                popup = {
                    size = {
                        height = "80%",
                        width = "50%",
                    },
                    position = "50%",
                    border = "rounded",
                },
            },
            filesystem = {
                follow_current_file = true,
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
        })
    end,
}
