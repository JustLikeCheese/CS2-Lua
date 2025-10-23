-- Counter-Strike 2 API
-- 提供 CS2 API 的封装

local cfg = cs2.cfg
--- 绑定按键
--- Bind key
--- @param key string
--- @param command any
function cs2.bind(key, command)
    cs2.func("bind", cfg.formatString(key), cfg.formatArg(command))
end

--- 创建别名
--- Create alias
--- @param key string
--- @param command any
function cs2.alias(key, command)
    cs2.func("alias", cfg.formatString(key), cfg.formatArg(command))
end

--- 输出文本
--- Print text
function cs2.print(text)
    cs2.func("echo", cfg.formatString(text))
end

--- 输出文本
--- Print text
function cs2.println(text)
    cs2.func("echoln", cfg.formatString(text))
end

--- 清空 CS2 控制台输出
--- Clear CS2 console output
function cs2.clear()
    cs2.run("clear")
end

--- 运行 CS2 脚本
--- Run CS2 script
function cs2.exec(path)
    if type(path) == "string" then
        cs2.func("exec", cfg.formatString(path))
    elseif type(path) == "table" then
        for _, v in ipairs(path) do
            cs2.exec(v)
        end
    else
        cs2.core.error("Invalid argument type: " .. type(path))
    end
end

-- 触发 CS2 事件
function cs2.event(name)
    cs2.run(name)
end