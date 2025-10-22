--- 兼容 table.concat
--- 提供一个列表，其所有元素都是字符串或数字，返回字符串 list[i]..sep..list[i+1] ··· sep..list[j]。
table.concat = table.concat or function(t, sep, i, j)
    sep = sep or ""
    i = i or 1
    j = j or #t
    if i > j then
        return ""
    end
    local result = tostring(t[i])
    for k = i + 1, j do
        result = result .. sep .. tostring(t[k])
    end
    return result
end

--- 读取文件内容
--- @param filename string
--- @return string
local function readFile(filename)
    local file = io.open(filename, "rb")
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
function cs2.build(filename, multilines, ignore)
    if not ignore then
        filename = filename or cs2.arg[1]
        multilines = multilines or cs2.arg[2]
    end
    local cfg = cs2._build(cs2.queue, multilines)
    if type(filename) == "string" then
        writeFile(filename, cfg)
    else
        print(cfg)
    end
    -- 清空代码队列
    cs2.code = {}
    return cfg
end