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
--- @param filename string|nil
--- @param multilines boolean|nil
--- @return string
function cs2.build(filename, multilines)
    filename = cs2.filename or filename
    multilines = cs2.multilines or multilines
    local cfg = cs2.cfg.compile(cs2.queue, multilines)
    if type(filename) == "string" then
        writeFile(filename, cfg)
    else
        print(cfg)
    end
    -- 清空代码队列
    cs2.code = {}
    return cfg
end