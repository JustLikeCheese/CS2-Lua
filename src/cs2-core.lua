require "cs2-comp"
cs2.core = { queue = {}, warnings = {}, multilines = true, stdout = false, binding = {} }

--- 使用例子
--- ```bash
--- lua main.lua                # 构建脚本, 默认多行输出
--- lua main.lua 1              # 构建脚本, 设置单行输出
--- lua main.lua output.cfg     # 指定输出脚本文件, 默认多行输出
--- lua main.lua output.cfg 1   # 指定输出脚本文件, 设置单行输出
--- lua main.lua nil 1          # 使用控制台输出, 设置单行输出
--- lua main.lua nil nil        # 使用控制台输出, 默认多行输出
--- ```
cs2.core.init = function()
    -- 初始化控制台参数
    local arg1 = arg[1]
    local arg2 = arg[2]
    if arg2 ~= nil then
        if arg1 == "nil" or arg1 == "false" or arg1 == "" or arg1 == "0" then
            cs2.core.stdout = true
        else
            cs2.core.filename = arg1
        end
        arg1 = arg2
    end
    if arg1 ~= nil and arg1 ~= "nil" and arg1 ~= "false" and arg1 ~= "" and arg1 ~= "0" then
        cs2.core.multilines = false
    end
    -- 加载用户配置
    for _, filename in ipairs(io.list('user')) do
        if filename:match("%.lua$") then
            local config = dofile("user/" .. filename)
            for k, v in pairs(config) do
                cs2.core.binding[tostring(k)] = tostring(v)
            end
        end
    end
end

cs2.core.error = function(message)
    error("[CS2-Lua] [Error] " .. message)
end

cs2.core.warning = function(message)
    print("[CS2-Lua] [Warning] " .. message)
end

cs2.core.enableFeature = function()
    setmetatable(cs2, {
        __index = function(t, k)
            local v = rawget(cs2, k)
            if v ~= nil then
                return v
            elseif type(k) == "string" then
                table.insert(cs2.core.warnings, k)
                return function(...)
                    cs2.func(k, ...)
                end
            end
        end
    })
end

--- 添加代码到构建队列
--- @param code table
function cs2.add(code)
    if not code then
        return
    end
    table.insert(cs2.core.queue, code)
end

--- 恢复绑定
--- Restore key binding
--- @param key string
function cs2.default(key)
    local original = cs2.core.binding[key]
    if original then
        return cs2.func(key, original)
    end
    cs2.error("No default binding for key:" .. key)
end

return cs2.core
