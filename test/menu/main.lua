require "cs2"

-- 创建菜单
local menu = cs2.ui.Menu("Lua 辅助菜单")
-- 菜单项标题, 绑定按键, 绑定事件
menu.add("1. 一键添加 Bot", "1", function()
    for i=1, 10 do
        cs2.run("bot_add")
    end
end)

menu.add("2. 设置 Bot 难度", "2", function()
    -- 创建子菜单
    local subMenu = cs2.ui.Menu("Bot 难度设置")
    subMenu.add("1. 简单", "1", function()
        cs2.run("bot_difficulty 0")
    end)
    subMenu.add("2. 中等", "2", function()
        cs2.run("bot_difficulty 1")
    end)
    subMenu.add("3. 困难", "3", function()
        cs2.run("bot_difficulty 2")
    end)
    subMenu.add("4. 专家", "4", function()
        cs2.run("bot_difficulty 3")
    end)
    subMenu.show()
end)

menu.add("3. 退出", "3", function(menu)
    menu.exit() -- 退出菜单
end)

-- 绑定 X 键显示菜单
cs2.bind("x", function()
    menu.show()
end)

cs2.build()
