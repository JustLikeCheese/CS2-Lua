---@diagnostic disable: lowercase-global
cs2 = { code = {}, arg = arg }
require "cs2-api"

--- 添加代码到构建队列
--- @param code any
function cs2.add(code)
    table.insert(cs2.code, code)
end

--- 加载 CFG 配置
--- Load CS2 cfg
--- @param t table
function cs2.config(t)
    local formatted = cs2.format(t)
    for i = 1, #formatted do
        cs2.add(formatted[i])
    end
end

--- 格式化参数为 CFG 格式
--- @param arg any
--- @return any
function cs2.format(arg)
    local argType = type(arg)
    if argType == "boolean" or argType == "number" then
        return tostring(arg)
    elseif argType == "nil" then
        return "\"\""
    elseif argType == "string" then
        -- 如果字符串包含空格或制表符，添加引号
        if string.find(arg, "[ \t]") ~= nil then
            return "\"" .. arg .. "\""
        else
            return arg
        end
    elseif argType == "table" then
        local config = {}
        for k, v in pairs(arg) do
            local keyType = type(k)
            if keyType == "string" then
                table.insert(config, k .. " " .. cs2.format(v)) -- key value
            elseif keyType == "number" then
                table.insert(config, v) -- value
            end
        end
        return config
    elseif argType == "function" then
        local savedCode = cs2.code -- 保存构建代码队列
        cs2.code = {}
        arg()
        local builtConfig = cs2._build(false)
        cs2.code = savedCode
        builtConfig = builtConfig:gsub(";+", ";"):gsub("^;", ""):gsub(";$", "") -- 去除多余的分号
        return "\"" .. builtConfig .. "\""
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
        line = line .. " " .. cs2.format(args[i])
    end
    cs2.add(line)
end

--- 运行 CS2 命令
--- Run CS2 command
--- @param command string
function cs2.run(command)
    cs2.add(command)
end

--- 清空 CS2 控制台输出
--- Clear CS2 console output
function cs2.clear()
    cs2.run("clear")
end

--- 内部构建函数
--- @param multilines boolean|nil
--- @return string
function cs2._build(multilines)
    local codeLines = {}
    for i = 1, #cs2.code do
        local line = cs2.code[i]
        local lineType = type(line)
        if lineType == "table" then
            -- 处理表格式的代码
            for j = 1, #line do
                local subline = line[j]
                table.insert(codeLines, subline .. ";")
            end
        elseif lineType == "string" then
            -- 处理字符串格式的代码
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

--- 读取文件内容
--- @param filename string
--- @return string
local function readFile(filename)
    local file = io.open(filename, "r")
    if not file then
        error("[CS2.lua] Can't open file: " .. filename)
    end
    local content = file:read("*all")
    file:close()
    return content
end

--- 写入文件
--- @param filename string
--- @param text string
local function writeFile(filename, text)
    local file = io.open(filename, "wb")
    if not file then
        error("[CS2.lua] Can't open file: " .. filename)
    end
    file:write(text)
    file:close()
end

--- 构建 Lua 脚本为 CFG
--- Build Lua script as CFG
--- @param filename any 输出文件名，nil 则输出到控制台
--- @param multilines any 是否多行格式
--- @param ignore any 是否忽略命令行参数
--- @return string
function cs2.build(filename, multilines, ignore)
    if not ignore then
        filename = filename or cs2.arg[1]
        multilines = multilines or cs2.arg[2]
    end
    local cfg = cs2._build(multilines)
    if type(filename) == "string" then
        writeFile(filename, cfg)
    else
        print(cfg)
    end
    -- 清空代码队列
    cs2.code = {}
    return cfg
end

return cs2