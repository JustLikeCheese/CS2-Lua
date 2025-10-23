require "cs2-comp"
cs2.core = { queue = {}, warnings = {} }

cs2.core.init = function()
    local arg1 = arg[1]
    local arg2 = arg[2]
    if arg2 then
        cs2.filename = arg[1]
        arg1 = arg2
    end
    if arg1 ~= nil and arg1 ~= "nil" and arg1 ~= "false" and arg1 ~= "" then
        cs2.multilines = true
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

return cs2.core