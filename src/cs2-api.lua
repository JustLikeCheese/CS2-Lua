--- 绑定按键
--- Bind key
function cs2.bind(key, command)
    cs2.func("bind", key, command)
end

--- 创建别名
--- Create alias
function cs2.alias(key, command)
    cs2.func("alias ", key, command)
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