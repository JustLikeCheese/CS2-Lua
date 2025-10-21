package.path = package.path .. ";C:/Users/Cheese/Desktop/CS2-Lua/src/?.lua"
require "cs2"
cs2.config {
    mp_buy_anywhere = 1, -- 允许任意位置购买
    sv_grenade_trajectory_prac_pipreview = true, -- 显示投掷物轨迹
    ammo_grenade_limit_total = 5, -- 可以购买五颗手雷这样诱饵弹也可以买了
    mp_buytime = 99999999, -- 无限购买时间
    sv_infinite_ammo = 1, -- 无限子弹及投掷物
    -- 兼容 CFG
    "sv_showimpacts 0", -- 显示子弹落点
    "cl_showfps 0", -- 显示帧数
}
cs2.clear()
cs2.bind("x", "noclip") -- X 键飞行
cs2.print("跑图脚本已加载") -- 控制台输出消息
cs2.build("output.cfg") -- 构建 CFG