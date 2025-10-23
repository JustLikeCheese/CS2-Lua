--- 兼容 table.concat
--- 提供一个列表，其所有元素都是字符串或数字，返回字符串 list[i]..sep..list[i+1] ··· sep..list[j]。
table.concat = table.concat or function(t, sep, i, j)
    sep = sep or ""
    i = i or 1
    j = j or #t
    if i > j then
        return ""
    end
    local result = tostring(t[i])
    for k = i + 1, j do
        result = result .. sep .. tostring(t[k])
    end
    return result
end

-- string.split
function string.split(str, split)
    local result = {}
    string.gsub(str, '[^' .. split .. ']+', function(w)
        table.insert(result, w)
    end)
    return result
end

-- string.random
function string.random(n)
    local chars = {
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
        "k", "l", "m", "n", "o", "p", "q", "r", "s",
        "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F",
        "G", "H", "I", "J", "K",
        "L", "M", "N",
        "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "_"
    }
    local str = ""
    for i = 1, n do
        str = str .. chars[math.random(#chars)]
    end
    return str
end

---@diagnostic disable-next-line: lowercase-global
function dump(o)
    local t = {}
    local _t = {}
    local _n = {}
    local space, deep = string.rep(' ', 2), 0
    local type = _ENV.type
    local function _ToString(o, _k)
        if type(o) == ('number') then
            table.insert(t, o)
        elseif type(o) == ('string') then
            table.insert(t, string.format('%q', o))
        elseif type(o) == ('table') then
            local mt = getmetatable(o)
            if mt and mt.__tostring then
                table.insert(t, tostring(o))
            else
                deep = deep + 2
                table.insert(t, '{')
                for k, v in pairs(o) do
                    if v == _G then
                        table.insert(t, string.format('\r\n%s%s\t=%s ;', string.rep(space, deep - 1), k, "_G"))
                    elseif v ~= package.loaded then
                        if tonumber(k) then
                            k = string.format('[%s]', k)
                        else
                            k = string.format('[\"%s\"]', k)
                        end
                        table.insert(t, string.format('\r\n%s%s\t= ', string.rep(space, deep - 1), k))
                        if v == nil then
                            table.insert(t, string.format('%s ;', "nil"))
                        elseif type(v) == ('table') then
                            if _t[tostring(v)] == nil then
                                _t[tostring(v)] = v
                                local _k = _k .. k
                                _t[tostring(v)] = _k
                                _ToString(v, _k)
                            else
                                table.insert(t, tostring(_t[tostring(v)]))
                                table.insert(t, ';')
                            end
                        else
                            _ToString(v, _k)
                        end
                    end
                end
                table.insert(t, string.format('\r\n%s}', string.rep(space, deep - 1)))
                deep = deep - 2
            end
        else
            table.insert(t, tostring(o))
        end
        table.insert(t, " ;")
        return t
    end
    t = _ToString(o, '')
    return table.concat(t)
end

function io.list(path)
    local is_windows = package.config:sub(1, 1) == '\\'
    local cmd
    if is_windows then
        cmd = 'dir "' .. path .. '" /b'
    else
        cmd = 'ls -1 "' .. path .. '"'
    end

    local files = {}
    local p = io.popen(cmd)
    if p then
        for file in p:lines() do
            table.insert(files, file)
        end
        p:close()
    end
    return files
end
