---@diagnostic disable: lowercase-global
cs2 = {
    code = {
        "echo \"Script build with CS2.lua\"",
    }
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

--- 绑定按键
--- Bind key
function cs2.bind(key, command)
    cs2.add("bind \"" .. tostring(key) .. "\" " .. tostring(command))
end

--- 输出文本
--- Print text
function cs2.print(text)
    cs2.add("echo \"" .. tostring(text) .. "\"")
end

--- 运行 CS2 命令
--- Run CS2 command
function cs2.run(command)
    cs2.add(command)
end

--- 清空 CS2 控制台输出
--- Clear CS2 console output
function cs2.clear()
    cs2.add("clear")
end

--- 构建 Lua 脚本为 CFG
--- Build Lua script as CFG
--- @param mutlines boolean
function cs2.build(mutlines)
    if mutlines then
        for i = 1, #cs2.code do
            print(cs2.code[i])
        end
        return
    end
    local codes = ""
    for i = 1, #cs2.code do
        codes = codes .. cs2.code[i] .. ";"
    end
    print(codes)
end

return cs2