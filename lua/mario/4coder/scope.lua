-- Nested scope backgrounds.  Only a handful of range extmarks are changed per
-- update; hlchunk.nvim continues to provide its efficient structural outline.
local M = {}

local ns = vim.api.nvim_create_namespace("mario_4coder_scope")
local states = {}
local state_store = require("mario.core.state")
local supported = { c = true, cpp = true, rust = true, zig = true }
-- A deep control-flow nest is still cheap: this is one range extmark per
-- ancestor, not a per-line redraw.  Keep enough levels to show the complete
-- path in real-world Rust match/loop code.
local max_scopes = 32

local scope_types = {
    block = true, compound_statement = true, declaration_list = true,
    function_definition = true, function_item = true, function_declaration = true,
    method_definition = true, class_definition = true, class_specifier = true,
    struct_specifier = true, struct_item = true, union_item = true,
    enum_specifier = true, enum_item = true, impl_item = true, trait_item = true,
    namespace_definition = true, module = true, mod_item = true,
    if_statement = true, if_expression = true, for_statement = true,
    for_expression = true, while_statement = true, while_expression = true,
    switch_statement = true, switch_expression = true, match_expression = true,
    match_arm = true, loop_expression = true, closure_expression = true,
    catch_clause = true, test_declaration = true, container_declaration = true,
}

local function is_scope(node)
    local kind = node:type()
    return scope_types[kind]
        or kind:match("_block$") ~= nil
        or kind:match("_body$") ~= nil
end

local function semantic_scope(node)
    -- A block is implementation detail; its owning `if`, `for`, function, or
    -- match expression is the scope a 4coder-style guide should represent.
    local kind = node:type()
    if kind == "block" or kind == "compound_statement" or kind:match("_block$") then
        local parent = node:parent()
        if parent and is_scope(parent) then return parent end
    end
    return node
end

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
    for depth = 2, max_scopes do
        local amount = 0.48 * (0.78 ^ (depth - 2))
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

local function scope_label(bufnr, node)
    -- `semantic_scope` already promoted a raw block to its owner, so use the
    -- scope node itself.  Its text begins with exactly the header we need.
    local header = (vim.treesitter.get_node_text(node, bufnr) or ""):match("^(.-)%s*{")
    if not header then return end
    header = header:gsub("%s+", " "):gsub("%s+$", "")
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
        if node:named() and is_scope(node) then
            local scope = semantic_scope(node)
            local sr, sc, er, ec = scope:range()
            local key = table.concat({ sr, sc, er, ec }, ":")
            if not seen[key] and (er > sr or ec > sc) then
                seen[key] = true
                scopes[#scopes + 1] = {
                    start_row = sr,
                    start_col = sc,
                    end_row = er,
                    end_col = ec,
                    label = scope_label(bufnr, scope),
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
    local key = vim.inspect({ scopes = scopes, first = visible_start, last = visible_end })
    local state = states[bufnr] or { marks = {} }
    states[bufnr] = state
    if state.key == key then return end
    clear(bufnr)

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
        -- hlchunk draws the innermost scope.  These guide marks deliberately
        -- begin with its parent, so a cursor in `if` also shows its enclosing
        -- `match`, `for`, and function without drawing a duplicate inner box.
        if depth > 1 then
            local last_scope_line = scope.end_col == 0 and scope.end_row - 1 or scope.end_row
            local first = math.max(scope.start_row + 1, visible_start)
            local last = math.min(last_scope_line, visible_end)
            local guide_col = math.max(0, scope.start_col - 1)
            for line = first, last do
                local closing = line == last
                -- Keep the whole guide in the preceding indentation cell.
                -- That aligns the corner with its vertical and never masks
                -- the source closing brace.
                if not closing or guide_col < scope.start_col then
                    state.marks[#state.marks + 1] = vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
                    virt_text = { { closing and "└" or "│", "FourCoderScopeGuide" .. depth } },
                    virt_text_pos = "overlay",
                    virt_text_win_col = guide_col,
                    priority = 140 - depth,
                    })
                end
            end
        end
        -- Every ancestor gets its own closing-brace annotation, mirroring
        -- 4coder's complete current scope stack rather than only the leaf.
        if scope.label then
            local label_row = scope.end_row
            if scope.end_col == 0 and label_row > scope.start_row then label_row = label_row - 1 end
            state.marks[#state.marks + 1] = vim.api.nvim_buf_set_extmark(bufnr, ns, label_row, 0, {
                virt_text = { { " " .. scope.label, "FourCoderScopeLabel" } },
                virt_text_pos = "eol",
                priority = 130,
            })
        end
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
    vim.g.fourcoder_scope_backgrounds = state_store.get("fourcoder_scope_backgrounds", true)
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
            if timers[args.buf] then timers[args.buf]:stop(); timers[args.buf] = nil end
        end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = setup_highlights })
end

return M
