-- CS2 CFG 库
-- 用于解析和编译 Counter-Strike 2 配置文件
cs2.cfg = {}

--- 解析 CFG
--- @param input string
--- @return table
function cs2.cfg.parse(input)
    if type(input) ~= "string" then
        cs2.core.error("input must be a string")
        return {}
    end
    local lines = string.split(input, "\n")
    local configs = {}
    for _, line in ipairs(lines) do
        local currentConfig = {}
        local stringMode = nil -- 1: ", 2: '
        local escapeMode = false
        local startIndex = nil
        -- 遍历当前行的字符
        for i = 1, #line do
            local c = line[i]
            if stringMode then
                if c == "\\" then                                           -- 处理转义
                    escapeMode = true
                elseif c == '"' and stringMode == 1 and not escapeMode then -- 结束双引号
                    stringMode = nil
                    table.insert(currentConfig, string.sub(line, startIndex, i))
                elseif c == "'" and stringMode == 2 and not escapeMode then -- 结束单引号
                    stringMode = nil
                    table.insert(currentConfig, string.sub(line, startIndex, i))
                else
                    escapeMode = false
                end
            else
                if c == ";" then       -- 分号, 保存当前配置, 并创建新的配置
                    if startIndex then -- 前面存在未结束的元素
                        table.insert(currentConfig, string.sub(line, startIndex, i - 1))
                        startIndex = nil
                    end
                    if #currentConfig > 0 then -- 保存当前配置
                        table.insert(configs, currentConfig)
                    end
                    currentConfig = {}                      -- 创建新的配置
                    goto continue
                elseif c == "/" and line[i + 1] == "/" then -- 遇到注释跳过当前行
                    if startIndex then                      -- 前面存在未结束的元素
                        table.insert(currentConfig, string.sub(line, startIndex, i - 1))
                        startIndex = nil
                    end
                    if #currentConfig > 0 then -- 保存当前配置
                        table.insert(configs, currentConfig)
                    end
                    break
                elseif c == " " or c == "\t" then -- 空格/制表符结束元素
                    if startIndex then
                        table.insert(currentConfig, string.sub(line, startIndex, i - 1))
                        startIndex = nil
                    end
                elseif c == "\"" then
                    if startIndex then -- 前面存在未结束的元素
                        table.insert(currentConfig, string.sub(line, startIndex, i - 1))
                    end
                    startIndex = i
                    stringMode = 1
                elseif c == "'" then
                    if startIndex then -- 前面存在未结束的元素
                        table.insert(currentConfig, string.sub(line, startIndex, i - 1))
                    end
                    startIndex = i
                    stringMode = 2
                else
                    -- 为普通字符且 startIndex 为空，则设置
                    if not startIndex then
                        startIndex = i
                    end
                end
            end
            -- 处理最后一个元素
            if i == #line then
                if startIndex then
                    -- 检查字符串是否未结束
                    local str = string.sub(line, startIndex)
                    if stringMode == 1 then
                        str = str .. '"'
                        cs2.core.warning("string " .. str .. " is not closed in line " .. i)
                    elseif stringMode == 2 then
                        str = str .. "'"
                        cs2.core.warning("string " .. str .. " is not closed in line " .. i)
                    end
                    table.insert(currentConfig, str)
                end
                if #currentConfig > 0 then     -- 保存当前配置
                    table.insert(configs, currentConfig)
                end
            end
            ::continue::
        end
    end
    return configs
end

--- 编译 Table 为 CFG
--- @param tbl table
--- @param multilines boolean|nil
--- @return string
function cs2.cfg.compile(tbl, multilines)
    local result = ""
    for _, cfgline in ipairs(tbl) do
        -- { bind, x, "noclip"}
        local line = cfgline[1]
        for i = 2, #cfgline do
            line = line .. " " .. cfgline[i]
        end
        if multilines then
            result = result .. line .. "\n"
        else
            result = result .. line .. ";"
        end
    end
    return result
end

--- 格式化 CFG
--- @param input string
--- @param multilines boolean|nil
--- @return string
function cs2.cfg.format(input, multilines)
    return cs2.cfg.compile(cs2.cfg.parse(input), multilines)
end

-- Lua 值转 CFG 值

--- 格式化 Lua 字符串为 CFG 值
--- 如果字符串包含空格或制表符，则自动添加引号
--- @param str string
--- @return string, boolean
function cs2.cfg.formatString(str)
    if string.find(str, "[ \t]") then
        return "\"" .. str .. "\"", true
    else
        return str, false
    end
end

--- 格式化 Lua 表为 CFG 值
--- @param tbl table
--- @return string, boolean
function cs2.cfg.formatTable(tbl)
    local blank = false
    local config = {}
    for key, value in pairs(tbl) do
        local key_type = type(key)
        local value_type = type(value)
        local str = nil
        local str_blank = false
        if key_type == "number" then
            if value_type == "string" then
                str, str_blank = cs2.cfg.formatString(value)
            elseif value_type == "table" then
                str, str_blank = cs2.cfg.formatTable(value)
            elseif value_type == "function" then
                str, str_blank = cs2.cfg.formatFunction(value), true
            elseif value_type == "boolean" or value_type == "number" then
                table.insert(config, tostring(value))
            else
                cs2.core.error("Unsupported type " .. value_type)
            end
        end
        table.insert(config, str)
        blank = blank or str_blank
    end
    local builtConfig = table.concat(config, ";")
    if blank then builtConfig = "\"" .. builtConfig .. "\"" end
    return builtConfig, blank
end

--- 格式化 Lua 函数为 CS2 参数
--- @param func function
--- @return string
function cs2.cfg.formatFunction(func)
    local oldQueue = cs2.core.queue
    local tempQueue = {}
    cs2.core.queue = tempQueue

    local success, err = pcall(func)
    if not success then
        cs2.core.warning(err)
        cs2.core.warning(debug.traceback())
    end

    cs2.core.queue = oldQueue
    local builtConfig = cs2.cfg.compile(tempQueue, false)
    return (cs2.cfg.formatString(builtConfig))
end

--- Lua 值转 CFG 属性值
--- @param value any
--- @return string
function cs2.cfg.formatArg(value)
    local arg_type = type(value)
    if arg_type == "string" then
        return (cs2.cfg.formatString(value))
    elseif arg_type == "number" or arg_type == "boolean" then
        return tostring(value)
    elseif arg_type == "table" then
        return (cs2.cfg.formatTable(value))
    elseif arg_type == "function" then
        return (cs2.cfg.formatFunction(value))
    else
        cs2.core.error("Unsupported type " .. arg_type)
    end
    return ""
end

---@diagnostic disable-next-line: lowercase-global
vstr = function(str)
    return (cs2.cfg.formatString(tostring(str)))
end

return cs2.cfg
