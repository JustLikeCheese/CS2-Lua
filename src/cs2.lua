---@diagnostic disable: lowercase-global
cs2 = {
    code = {}
}

function cs2.add(code)
    if type(code) ~= "string" then
        error("[CS2.lua] Code must be string")
        return
    end
    table.insert(cs2.code, code)
end

function cs2._config(t)
    local _type = nil
    local _config = {}
    for k, v in pairs(t) do
        _k_type = type(k)
        if _k_type == "string" then
            table.insert(_config, k .. " " .. cs2.format(v) .. ";")
        elseif _k_type == "number" then
            table.insert(_config, v .. ";")
        end
    end
    return _config
end

--- 加载 CFG 配置
--- Load CS2 cfg
--- @param t table
function cs2.config(t)
    local _config = cs2._config(t)
    for i=1, #_config do
        cs2.add(_config[i])
    end
end

function cs2.format(arg)
    local _type = type(arg)
    if _type == "boolean" or _type == "number" then
        return tostring(arg)
    elseif _type == "nil" then
        return "\"\""
    elseif _type == "string" then
        if string.find(arg, "%s") ~= nil then
            return "\"" .. arg .. "\""
        else
            return arg
        end
    else
        error("[CS2.lua] Unsupported type: " .. _type)
    end
end

function cs2.func(funcName, ...)
    local line = funcName
    local args = { ... }
    for i = 1, #args do
        line = line .. " " .. cs2.format(args[i])
    end
    cs2.add(line)
end

-- 还原值
-- Revert value to default
function cs2.default(key, value)
    cs2.func("default", key, value)
end

--- 绑定按键
--- Bind key
function cs2.bind(key, command)
    cs2.func("bind", key, command)
end

--- 创建别名
--- Create alias
function cs2.alias(key, command)
    cs2.func("alias ", key, command)
end

--- 输出文本
--- Print text
function cs2.print(text)
    cs2.func("print", text)
end

--- 运行 CS2 命令
--- Run CS2 command
function cs2.run(command)
    cs2.add(command)
end

--- 清空 CS2 控制台输出
--- Clear CS2 console output
function cs2.clear()
    cs2.run("clear")
end

function cs2._build(mutlines)
    local codes = ""
    if mutlines then
        for i = 1, #cs2.code do
            codes = codes .. cs2.code[i] .. "\n"
        end
    else
        for i = 1, #cs2.code do
            codes = codes .. cs2.code[i] .. ";"
        end
    end
    return codes
end

local function readFile(filename)
    local file = io.open(filename, "r")
    if not file then
        error("[CS2.lua] Can't open file: " .. filename)
        return
    end
    return file:read("*all")
end

local function writeFile(filename, text)
    local file = io.open(filename, "w")
    if not file then
        error("[CS2.lua] Can't open file: " .. filename)
        return
    end
    file:write(text)
    file:close()
end

--- 构建 Lua 脚本为 CFG
--- Build Lua script as CFG
--- @--- @param filename boolean|nil|string
--- @--- @param mutlines boolean|nil
function cs2.build(filename, mutlines)
    filename = filename or arg[1]
    mutlines = mutlines or arg[2]
    local cfg = cs2._build(mutlines)
    if type(filename) == "string" then
        writeFile(filename, cfg)
    else
        print(cfg)
    end
    cs2.code = {}
end

return cs2
