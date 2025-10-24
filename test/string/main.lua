require "cs2"
cs2.bind("x", function()
    cs2.run([[
        say_team "哈哈哈"
        say_team "啊啊啊"
        say_team "呀呀呀"
    ]])
end)
cs2.build()