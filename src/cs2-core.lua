require "cs2-comp"
cs2.core = {}
cs2.core.error = function(message)
    error("[CS2-Lua] [Error] " .. message)
end

cs2.core.warning = function(message)
    print("[CS2-Lua] [Warning] " .. message)
end

return cs2.core