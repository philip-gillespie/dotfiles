-- repl.lua

local M = {}

local function send_to_fifo(code)
    local fifo = io.open("/tmp/repl_pipe", "w")
    if fifo then
        fifo:write(code)
        fifo:close()
    end
end

function M.send_hello_world()
    send_to_fifo('print("hello from neovim!")')
end

function M.send_current_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local code = table.concat(lines, "\n")
    send_to_fifo(code)
end

function M.send_currentLine()
    local line = vim.api.nvim_get_current_line()
    send_to_fifo(line)
end

function M.send_visual_lines()
    -- Save current visual selection before it's lost
    local start_line = vim.fn.line("v") - 1
    local end_line = vim.fn.line(".") 
    
    -- Make sure start_line is actually the start
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
    local code = table.concat(lines, "\n")
    send_to_fifo(code)
end

function M.send_visual_selection()
    local start_pos = vim.fn.getpos("'<") -- {bufnorm, lnum, col, off}
    local end_pos = vim.fn.getpos("'>")

    local start_line, start_col = start_pos[2], start_pos[3]
    local end_line, end_col = end_pos[2], end_pos[3]

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_col, end_col)
    else
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end

    local code = table.concat(lines, "\n")
    send_to_fifo(code)
end

function M.send_visual_block()
    local start_pos = vim.fn.getpos("'<") -- {bufnorm, lnum, col, off}
    local end_pos = vim.fn.getpos("'>")

    local start_line, start_col = start_pos[2], start_pos[3]
    local end_line, end_col = end_pos[2], end_pos[3]

    -- ensure start < end
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    if start_col > end_col then
        start_col, end_col = end_col, start_col
    end

    -- Get lines from buffer
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    -- Slice each line to the block columns
    for i, line in ipairs(lines) do
        local line_len = #line
        local s = math.min(start_col, line_len)
        local e = math.min(end_col, line_len)
        lines[i] = string.sub(line, s, e)
    end

    local code = table.concat(lines, "\n")
    send_to_fifo(code)
end

local function find_code_block()
    local current_buffer = 0
    local total_lines = vim.api.nvim_buf_line_count(current_buffer)
    local current_line = vim.api.nvim_win_get_cursor(current_buffer)[1]

    local cell_pattern = "^%s*#%s?%%"

    -- Search backwards for the previous cell marker
    local start_line = 1 -- default to start of file
    for i = current_line, 1, -1 do
        local line = vim.api.nvim_buf_get_lines(current_buffer, i - 1, i, false)[1]
        if line:match(cell_pattern) then
            start_line = i -- start ON the marker
            break
        end
    end

    -- Search forwards for the next cell marker
    local end_line = total_lines -- default to end of file
    for i = current_line + 1, total_lines do
        local line = vim.api.nvim_buf_get_lines(current_buffer, i - 1, i, false)[1]
        if line:match(cell_pattern) then
            end_line = i - 1
            break
        end
    end

    local lines = vim.api.nvim_buf_get_lines(current_buffer, start_line - 1, end_line, false)
    return start_line, end_line, lines
end

function M.send_code_block()
    local _, _, lines = find_code_block()
    local code = table.concat(lines, "\n")
    send_to_fifo(code)
end

function M.send_code_block_move_to_next()
    local _, end_line, lines = find_code_block()
    local code = table.concat(lines, "\n")
    send_to_fifo(code)

    local window = 0
    local current_buffer = 0
    local column = 0
    local total_lines = vim.api.nvim_buf_line_count(current_buffer)
    if end_line == total_lines then
        vim.api.nvim_win_set_cursor(window, { total_lines, column })
    else
        vim.api.nvim_win_set_cursor(window, { end_line + 1, column })
    end
end

function M.setup()
    vim.api.nvim_create_user_command("ReplSendHelloWorld", M.send_hello_world, {})
    vim.api.nvim_create_user_command("ReplSendCurrentBuffer", M.send_current_buffer, {})
    vim.api.nvim_create_user_command("ReplSendCurrentLine", M.send_currentLine, {})
    vim.api.nvim_create_user_command("ReplSendVisualLines", M.send_visual_lines, {})
    vim.api.nvim_create_user_command("ReplSendVisualSelection", M.send_visual_selection, {})
    vim.api.nvim_create_user_command("ReplSendVisualBlock", M.send_visual_block, {})
    vim.api.nvim_create_user_command("ReplSendCodeBlock", M.send_code_block, {})
    vim.api.nvim_create_user_command("ReplSendCodeBlockMoveNext", M.send_code_block_move_to_next, {})
end

return M
