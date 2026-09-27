-- Brace enclosure guides and closing labels, following 4coder QOL's
-- qol_draw_scopes. Terminal guides occupy indentation cells only.
local M = {}

local ns = vim.api.nvim_create_namespace("mario_4coder_scope")
local states = {}
local state_store = require("mario.core.state")
local supported = { c = true, cpp = true, rust = true, zig = true }
local max_scopes = 30

local function setup_highlights()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    local bg = normal.bg or 0x1e1e2e
    local fg = normal.fg or 0xcdd6f4
    local function mix(amount)
        local r = math.floor(((bg >> 16) & 0xff) * (1 - amount) + ((fg >> 16) & 0xff) * amount)
        local g = math.floor(((bg >> 8) & 0xff) * (1 - amount) + ((fg >> 8) & 0xff) * amount)
        local b = math.floor((bg & 0xff) * (1 - amount) + (fg & 0xff) * amount)
        return string.format("#%02x%02x%02x", r, g, b)
    end
    -- The closest block is a light tint; each ancestor fades, but remains
    -- discernible through the complete 4coder-style scope path.
    for depth = 1, max_scopes do
        local amount = 0.200 * (0.72 ^ (depth - 1))
        vim.api.nvim_set_hl(0, "FourCoderScope" .. depth, { bg = mix(amount) })
    end
    vim.api.nvim_set_hl(0, "FourCoderScopeLabel", { link = "Comment" })
    for depth = 1, max_scopes do
        local amount = depth == 1 and 0.48 or 0.25
        vim.api.nvim_set_hl(0, "FourCoderScopeGuide" .. depth, { fg = mix(amount) })
    end
end

local function clear(bufnr)
    local state = states[bufnr]
    if not state then return end
    for _, id in ipairs(state.marks) do
        pcall(vim.api.nvim_buf_del_extmark, bufnr, ns, id)
    end
    state.marks, state.key = {}, nil
end

local function scope_label(bufnr, node, opening)
    -- Bodies begin at the brace; their parent supplies the declaration header.
    if node:type() == "block" or node:type():match("_list$")
        or node:type():match("_body$") or node:type():match("_block$")
        or node:type() == "compound_statement" then
        node = node:parent() or node
    end
    local header = (vim.treesitter.get_node_text(node, bufnr) or ""):match("^(.-)%s*{")
    if not header or header:match("^%s*$") then
        -- Rust macro bodies contain token_tree nodes, not if/match nodes.
        -- Recover their header from the actual opening brace's source line.
        local row, col = opening:range()
        local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
        header = line:sub(1, col):gsub("^%s*}%s*", "")
    end
    header = header:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if header == "" then return end
    if #header > 56 then header = header:sub(1, 53) .. "..." end
    return header
end

local function collect_scopes(bufnr, row, col)
    -- Do not depend on a highlighter being enabled: scope navigation should
    -- still work when a user turns Tree-sitter colours off.
    local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    if not parser_ok or not parser then return {} end
    parser:parse()
    local ok, node = pcall(vim.treesitter.get_node, {
        bufnr = bufnr, pos = { row, col }, ignore_injections = false,
    })
    if not ok or not node then return {} end

    local scopes, seen = {}, {}
    while node and #scopes < max_scopes do
        -- Inspect direct delimiters so a declaration and its body cannot
        -- contribute duplicate outlines. This also includes struct literals.
        local opening, closing
        for child in node:iter_children() do
            if child:type() == "{" then opening = child end
            if child:type() == "}" then closing = child end
        end
        if opening and closing then
            local sr, sc = opening:range()
            local er, ec = closing:range()
            local key = table.concat({ sr, sc, er, ec }, ":")
            local inside = (row > sr or (row == sr and col >= sc))
                and (row < er or (row == er and col <= ec))
            if inside and er > sr and not seen[key] then
                seen[key] = true
                scopes[#scopes + 1] = {
                    start_row = sr,
                    start_col = sc,
                    end_row = er,
                    end_col = ec + 1,
                    label = scope_label(bufnr, node, opening),
                }
            end
        end
        node = node:parent()
    end
    return scopes
end

function M.update(bufnr, winid)
    if not vim.api.nvim_buf_is_valid(bufnr)
        or not vim.api.nvim_win_is_valid(winid)
        or vim.api.nvim_win_get_buf(winid) ~= bufnr
        or not supported[vim.bo[bufnr].filetype] then
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(winid)
    local scopes = collect_scopes(bufnr, cursor[1] - 1, cursor[2])
    -- Paint only the viewport.  This gives each nested ancestor a dependable
    -- full-line background without allocating marks for a large whole buffer.
    local visible_start = vim.fn.line("w0") - 1
    local visible_end = vim.fn.line("w$") - 1
    local leftcol = vim.api.nvim_win_call(winid, function() return vim.fn.winsaveview().leftcol end)
    local key = vim.inspect({ scopes = scopes, first = visible_start, last = visible_end,
        leftcol = leftcol, tick = vim.api.nvim_buf_get_changedtick(bufnr) })
    local state = states[bufnr] or { marks = {} }
    states[bufnr] = state
    if state.key == key then return end
    clear(bufnr)

    local labels = {}
    for depth, scope in ipairs(scopes) do
        if vim.g.fourcoder_scope_backgrounds then
            local last_scope_line = scope.end_col == 0 and scope.end_row - 1 or scope.end_row
            local first = math.max(scope.start_row, visible_start)
            local last = math.min(last_scope_line, visible_end)
            for line = first, last do
                state.marks[#state.marks + 1] = vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
                    line_hl_group = "FourCoderScope" .. depth,
                    priority = 120 - depth,
                })
            end
        end
        -- 4coder places the outline just left of the brace rectangle.
        -- Use the closing line's indentation as the terminal equivalent;
        -- never overlay a source character, including on outdented lines.
        local closing_text = vim.api.nvim_buf_get_lines(bufnr, scope.end_row, scope.end_row + 1, false)[1] or ""
        local indent = closing_text:match("^[ \t]*")
        local guide_col = math.max(0, vim.fn.strdisplaywidth(indent) - 1)
        local first = math.max(scope.start_row + 1, visible_start)
        local last = math.min(scope.end_row, visible_end)
        for line = first, last do
            local content = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or ""
            local whitespace = content:match("^[ \t]*")
            local column = guide_col - leftcol
            -- Position a single glyph, including beyond EOL on blank lines.
            -- Padding from a buffer anchor would erase outer guides when
            -- several scopes share an empty line or a tab.
            if column >= 0 and (content == whitespace
                or vim.fn.strdisplaywidth(whitespace) > guide_col) then
                state.marks[#state.marks + 1] = vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
                    virt_text = { { line == scope.end_row and "└" or "│", "FourCoderScopeGuide" .. depth } },
                    virt_text_pos = "overlay",
                    virt_text_win_col = column,
                    hl_mode = "combine",
                    priority = 140 - depth,
                })
            end
        end
        -- Every ancestor gets its own closing-brace annotation, mirroring
        -- 4coder's complete current scope stack rather than only the leaf.
        if scope.label then
            local label_row = scope.end_row
            if scope.end_col == 0 and label_row > scope.start_row then label_row = label_row - 1 end
            labels[label_row] = labels[label_row] or {}
            table.insert(labels[label_row], scope.label)
        end
    end
    -- Combine scopes closing on the same line so their EOL annotations
    -- cannot compete for the same display position.
    for row, names in pairs(labels) do
        state.marks[#state.marks + 1] = vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
            virt_text = { { " " .. table.concat(names, " · "), "FourCoderScopeLabel" } },
            virt_text_pos = "eol",
            priority = 130,
        })
    end
    state.key = key
end

function M.toggle_backgrounds()
    vim.g.fourcoder_scope_backgrounds = not vim.g.fourcoder_scope_backgrounds
    state_store.set("fourcoder_scope_backgrounds", vim.g.fourcoder_scope_backgrounds)
    for bufnr in pairs(states) do clear(bufnr) end
    local bufnr, winid = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
    M.update(bufnr, winid)
    vim.notify(
        "Scope backgrounds: " .. (vim.g.fourcoder_scope_backgrounds and "ON" or "OFF"),
        vim.log.levels.INFO,
        { title = "4coder" }
    )
end

function M.setup()
    vim.g.fourcoder_scope_backgrounds = state_store.get("fourcoder_scope_backgrounds", false)
    setup_highlights()
    vim.api.nvim_create_user_command("FourCoderToggleScopeBackground", M.toggle_backgrounds, {})
    local group = vim.api.nvim_create_augroup("MarioFourCoderScope", { clear = true })
    local timers = {}
    local function request_update(args)
        local bufnr = args.buf
        if timers[bufnr] then timers[bufnr]:stop() end
        timers[bufnr] = vim.defer_fn(function()
            timers[bufnr] = nil
            if vim.api.nvim_get_current_buf() == bufnr then
                M.update(bufnr, vim.api.nvim_get_current_win())
            end
        end, 35)
    end
    vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter", "TextChanged", "TextChangedI", "WinScrolled" }, {
        group = group,
        callback = request_update,
    })
    vim.api.nvim_create_autocmd({ "BufWipeout" }, {
        group = group,
        callback = function(args)
            states[args.buf] = nil
            if timers[args.buf] then
                timers[args.buf]:stop(); timers[args.buf] = nil
            end
        end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = setup_highlights })
end

return M
