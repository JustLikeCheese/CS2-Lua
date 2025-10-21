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

--- 加载 CFG 配置
--- Load CS2 cfg
--- @param t table
function cs2.config(t)
    local _type = nil
    for k, v in pairs(t) do
        _type = type(k)
        if _type == "string" then
            cs2.add(k .. " " .. tostring(v))
        elseif _type == "number" then
            cs2.add(tostring(v))
        end
    end
end

local function format(arg)
    return "\"" .. tostring(arg) .. "\""
end

function cs2.func(funcName, ...)
    local line = funcName
    local args = {...}
    for i = 1, #args do
        line = line .. " " .. format(args[i])
    end
    return line
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
    local cfg = cs2._build(mutlines)
    if type(filename) == "string" then
        writeFile(filename, cfg)
    else
        print(cfg)
    end
    cs2.code = {}
end

return cs2