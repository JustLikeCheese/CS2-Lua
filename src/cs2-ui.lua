cs2.ui = {}

-- Menu
local Menu = {

}

-- 绑定 View
cs2.ui.Menu = function(title)
    local menu = { items = {} }
    menu.title = title
    menu.id = string.random("menu", 8)
    menu.add = function(name, key, callback)
        local keyType = type(key)
        if callback == nil and keyType == "function" then
            callback = key
            key = nil
        end
        table.insert(menu.items, { name = name, key = key, callback = callback })
    end
    menu.show = function()
        -- 构建菜单
        local menu_show_id = menu.id .. "show"
        local menu_show_body = {}
        local items = menu.items
        cs2.run(menu_show_id)
    end
    return menu
end

return cs2.ui
