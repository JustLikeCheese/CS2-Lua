--- 加载 CFG 配置
--- Load CS2 cfg
--- @param arg any
function cs2.config(arg)
    -- 优先按顺序处理数组部分
    for i = 1, #arg do
        local value = arg[i]
        local value_type = type(value)
        if value_type == "string" then
            cs2.run(value)
        elseif value_type == "table" then
            cs2.config(value)
        end
    end
    -- 再处理键值对部分
    for key, value in pairs(arg) do
        if type(key) == "string" then
            local value_type = type(value)
            if value_type == "string" or value_type == "number" or value_type == "boolean" then
                cs2.func(key, vstr(value))
            else
                cs2.core.error("Invalid value type for key '" .. key .. "': " .. value_type)
            end
        end
    end
end

--- 运行 CS2 命令
--- Run CS2 command
--- @param command string
function cs2.run(command)
    local cfg = cs2.cfg.parse(command)
    for _, v in ipairs(cfg) do
        cs2.add(v)
    end
end

--- 绑定按键
--- Bind key
--- @param key string
--- @param command any
function cs2.bind(key, command)
    cs2.func("bind", cs2.cfg.formatString(key), cs2.cfg.formatArg(command))
end

--- 创建别名
--- Create alias
function cs2.alias(key, command)
    cs2.func("alias", key, command)
end

--- 输出文本
--- Print text
function cs2.print(text)
    cs2.func("echo", text)
end

--- 输出文本
--- Print text
function cs2.println(text)
    cs2.func("echoln", text)
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
        cs2.func("exec", path)
    elseif type(path) == "table" then
        for _, v in ipairs(path) do
            cs2.func("exec", v)
        end
    else
        error("Invalid path")
    end
end

-- 触发 CS2 事件
function cs2.event(name)
    cs2.add(name)
end