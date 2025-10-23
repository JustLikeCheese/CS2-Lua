--- 读取文件内容
--- @param filename string
--- @return string
local function readFile(filename)
    local file = io.open(filename, "rb")
    if not file then
        cs2.core.error("Can't open file: " .. filename)
---@diagnostic disable-next-line: missing-return-value
        return
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
        cs2.core.error("Can't open file: " .. filename)
        return
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
    -- 获取 WARNING 警告信息
    local warnings = cs2.core.warnings
    if #warnings > 0 then
        cs2.warn(table.concat(warnings, " "))
    end
    -- 获取默认参数
    filename = cs2.core.filename or filename
    multilines = cs2.core.multilines or multilines
    local cfg = cs2.cfg.compile(cs2.core.queue, multilines)
    if not cs2.core.stdout and type(filename) == "string" then
        writeFile(filename, cfg)
    else
        print(cfg)
    end
    -- 清空代码队列
    cs2.code = {}
    return cfg
end
