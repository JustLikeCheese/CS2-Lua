---@diagnostic disable: lowercase-global
cs2 = { queue = {} }

local arg1 = arg[1]
local arg2 = arg[2]
if arg2 then
    cs2.filename = arg[1]
    arg1 = arg2
end
if arg1 ~= "nil" and arg1 ~= "false" and arg1 ~= "" then
    cs2.multilines = true
end

--- 添加代码到构建队列
--- @param code table
function cs2.add(code)
    if not code then
        return
    end
    table.insert(cs2.queue, code)
end

--- 调用 CS2 函数
--- @param funcName string
--- @param ... any
function cs2.func(funcName, ...)
    cs2.add({ funcName, ... })
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

--- 运行 CS2 命令
--- Run CS2 command
--- @param command string
function cs2.run(command)
    local cfg = cs2.cfg.parse(command)
    for _, v in ipairs(cfg) do
        cs2.add(v)
    end
end

require "cs2-cfg"
require "cs2-core"
require "cs2-build"
require "cs2-api"
return cs2
