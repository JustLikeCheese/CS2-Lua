-- Counter-Strike 2 API
-- 提供 CS2 API 的封装

--- 运行 CS2 命令
--- Run CS2 command
--- @param command string
function cs2.run(command)
    local cfg = cs2.cfg.parse(command)
    print("Run command: " .. command)
    print(dump(cfg))
    for _, v in ipairs(cfg) do
        cs2.add(v)
    end
end

--- 调用 CS2 函数
--- @param funcName string
--- @param ... any
function cs2.func(funcName, ...)
    local args = {...}
    local config = funcName
    for i = 1, #args do
        config = config .. " " .. cs2.cfg.formatArg(args[i])
    end
    cs2.run(config)
end

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

--- 运行 CS2 脚本
--- Run CS2 script
function cs2.exec(path)
    if type(path) == "string" then
        cs2.func("exec", path)
    elseif type(path) == "table" then
        for _, v in ipairs(path) do
            cs2.exec(v)
        end
    else
        cs2.core.error("Invalid argument type: " .. type(path))
    end
end

--- 安全运行 CS2 脚本
--- Run CS2 script safely
function cs2.exec_safe(path)
    if type(path) == "string" then
        cs2.func("execifexists", path)
    elseif type(path) == "table" then
        for _, v in ipairs(path) do
            cs2.exec_safe(v)
        end
    else
        cs2.core.error("Invalid argument type: " .. type(path))
    end
end

--- 异步运行 CS2 脚本
--- Run CS2 script async
function cs2.exec_async(path)
    if type(path) == "string" then
        cs2.func("exec_async", path)
    elseif type(path) == "table" then
        for _, v in ipairs(path) do
            cs2.exec_async(v)
        end
    else
        cs2.core.error("Invalid argument type: " .. type(path))
    end
end

--- 绑定按键
--- Bind key
--- @param key string
--- @param command any
function cs2.bind(key, command)
    cs2.func("bind", key, command)
end

--- 创建别名
--- Create alias
--- @param key string
--- @param command any
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

-- 触发 CS2 事件
function cs2.event(name)
    cs2.run(name)
end
