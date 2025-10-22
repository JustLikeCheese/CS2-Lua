---@diagnostic disable: lowercase-global
cs2 = { queue = {}, arg = arg }

--- 添加代码到构建队列
--- 当传入 table 到构建代码队列时. 会根据构建时的 multilines 参数来判断是否要生成多行代码
--- @param code string|table
function cs2.add(code)
    table.insert(cs2.queue, code)
end

--- 格式化 Lua 字符串为 CS2 参数
--- 如果字符串包含空格或制表符，添加引号
--- @param str string
--- @return string
function cs2.formatString(str)
    if string.find(str, "[ \t]") then
        str = str:gsub("\\", "\\\\"):gsub("\"", "\\\"")
        return "\"" .. str .. "\""
    else
        return str
    end
end

--- 格式化 Lua 表为 CS2 参数
--- @param tbl table
--- @return table, boolean
function cs2.formatTable(tbl)
    local config = {}
    local blank = false
    for k, v in pairs(tbl) do
        local keyType = type(k)
        if keyType == "string" then
            table.insert(config, k .. " " .. cs2.formatArg(v))
            blank = true
        elseif keyType == "number" then
            local _type = type(v)
            if _type == "string" then
                if string.find(v, "[ \t]") ~= nil then
                    blank = true
                end
                table.insert(config, v)
            else
                error("[CS2.lua] Unsupported type: " .. _type)
            end
        end
    end
    return config, blank
end

--- 格式化 Lua 函数为 CS2 参数
--- @param func function
--- @return string
function cs2.formatFunction(func)
    local tempQueue = {}
    -- 创建 CS2 add 代理
    local virtualCS2 = setmetatable({}, {
        __index = function(t, k)
            if k == "add" then
                return function(code)
                    table.insert(tempQueue, code)
                end
            else
                return cs2[k]
            end
        end
    })
    -- 创建沙盒环境
    local sandbox = setmetatable({
        cs2 = virtualCS2
    }, {
        __index = _G
    })
    -- 支持 Lua 5.1
    if setfenv then
        setfenv(func, sandbox)
        func()
    else
        -- Lua 5.2+: 将函数转为字符串再用 load 加载并设置环境
        local chunk = string.dump(func)
        local vfunc, err = load(chunk, nil, "b", sandbox)
        if not vfunc then
            error("[CS2.lua] Failed to load function: " .. tostring(err))
        end
        vfunc()
    end
    local builtConfig = cs2._build(tempQueue, false)
    return "\"" .. builtConfig .. "\""
end

--- 格式化单个 Lua 参数为单个 CS2 参数
--- @param arg boolean|number|nil|string|table|function
--- @return string
function cs2.formatArg(arg)
    local argType = type(arg)
    if argType == "boolean" or argType == "number" then
        return tostring(arg)
    elseif argType == "nil" then
        return "\"\""
    elseif argType == "string" then
        return cs2.formatString(arg)
    elseif argType == "table" then
        local config, blank = cs2.formatTable(arg)
        local configString = table.concat(config, ";")
        if blank then
            configString = "\"" .. configString .. "\""
        end
        return configString
    elseif argType == "function" then
        return cs2.formatFunction(arg)
    else
        error("[CS2.lua] Unsupported type: " .. argType)
    end
end

--- 调用 CS2 函数
--- @param funcName string
--- @param ... any
function cs2.func(funcName, ...)
    local line = funcName
    local args = { ... }
    for i = 1, #args do
        line = line .. " " .. cs2.formatArg(args[i])
    end
    cs2.add(line)
end

--- 内部构建函数
--- @param queue table
--- @param multilines boolean|nil
--- @return string
function cs2._build(queue, multilines)
    local codeLines = {}
    for i = 1, #queue do
        local line = queue[i]
        local lineType = type(line)
        if lineType == "table" then
            for j = 1, #line do
                table.insert(codeLines, line[j] .. ";")
            end
        elseif lineType == "string" then
            table.insert(codeLines, line .. ";")
        else
            error("[CS2.lua] Unsupported type: " .. lineType)
        end
    end
    if multilines then
        return table.concat(codeLines, "\n")
    else
        return table.concat(codeLines, "")
    end
end

require "cs2-build"
require "cs2-api"
return cs2
