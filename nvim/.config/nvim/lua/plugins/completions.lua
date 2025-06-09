local M = {}
-- Displays builtin LSP snippets
table.insert(M, { "hrsh7th/cmp-nvim-lsp" })

-- Snippet Engine for neovim
table.insert(M, {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
    },
})

-- Completion engine for neovim

-- cmp config
local function format_suggestion(entry, vim_item)
    -- Truncate overly long detail (e.g., function signatures)
    local detail = entry.completion_item.detail
    if detail and #detail > 40 then
        vim_item.menu = detail:sub(1, 27) .. "..."
    else
        vim_item.menu = detail
    end

    return vim_item
end

local function expand_snippet(args)
    require("luasnip").lsp_expand(args.body)
end

local function config()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local cfg = {
        formatting = { format = format_suggestion },
        preselect = cmp.PreselectMode.Item,
        completion = { completeopt = "menu,menuone,noinsert" },
        snippet = { expand = expand_snippet },
        window = { documentation = { max_width = 50 } },
    }

    -- Mappings
    local keymaps = {}

    -- Built in
    keymaps["<CR>"] = cmp.mapping.confirm({ select = false })
    keymaps["<C-b>"] = cmp.mapping.scroll_docs(-4)
    keymaps["<C-f>"] = cmp.mapping.scroll_docs(4)
    keymaps["<C-e>"] = cmp.mapping.abort()

    -- Toggle suggestions
    local function toggle_suggestions()
        if cmp.visible() then
            cmp.close()
        else
            cmp.complete()
        end
    end
    keymaps["<C-Space>"] = toggle_suggestions

    -- Selecting with Tab
    local function next_suggestion(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end
    keymaps["<Tab>"] = next_suggestion
    local function prev_suggestion(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end
    keymaps["<S-Tab>"] = prev_suggestion

    -- Jump through snippets
    local function jump_forwards(fallback)
        if luasnip.jumpable(1) then
            luasnip.jump(1)
        else
            fallback()
        end
    end
    keymaps["<C-n>"] = cmp.mapping(jump_forwards, { "i", "s" })
    local function jump_backwards(fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end
    keymaps["<C-m>"] = cmp.mapping(jump_backwards, { "i", "s" })

    -- Use these specified keymaps
    cfg["mapping"] = cmp.mapping.preset.insert(keymaps)

    -- Sources for completion
    cfg["sources"] = cmp.config.sources({
        -- PRIMARY TIER - these sources are tried first
        { name = "luasnip", priority=1000},
        { name = "nvim_lsp", priority=900},
    }, {
        -- FALLBACK TIER - only shown if primary tier has no results
        { name = "buffer" },
    })
    return cfg
end

local function setup_completions()
    local cmp = require("cmp")
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
    cmp.setup(config())
end

table.insert(M, {
    "hrsh7th/nvim-cmp",
    config = setup_completions,
})

-- Toggle for autocompletions
local cmp_autocomplete_enabled = true
-- Toggle Autocomplete
function _G.ToggleCmpAutocomplete()
    cmp_autocomplete_enabled = not cmp_autocomplete_enabled
    require("cmp").setup({
        completion = {
            autocomplete = cmp_autocomplete_enabled and { require("cmp.types").cmp.TriggerEvent.TextChanged } or {},
        },
    })
    print("Autocomplete " .. (cmp_autocomplete_enabled and "enabled" or "disabled"))
end

-- Set as keymap
vim.keymap.set("n", "<leader>c", ToggleCmpAutocomplete, { desc = "Toggle autocomplete" })

-- Return the module
return M
