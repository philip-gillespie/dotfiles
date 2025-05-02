-- Only set this up once
local function setup_latex_autocompile()
    local group = vim.api.nvim_create_augroup("LatexAutoCompile", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.tex",
        group = group,
        callback = function()
            vim.cmd("silent !latexmk -xelatex -interaction=nonstopmode -synctex=1 %")
            vim.cmd("silent !latexmk -c %")
            vim.cmd("redraw!")
        end,
    })
end

setup_latex_autocompile()

return {}
