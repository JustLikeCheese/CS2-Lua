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

require "cs2-cfg"
require "cs2-core"
require "cs2-build"
require "cs2-api"
return cs2
