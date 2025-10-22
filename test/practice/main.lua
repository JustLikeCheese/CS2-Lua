require "cs2"
cs2.config {
    mp_buy_anywhere = 1,                         -- 允许任意位置购买
    sv_grenade_trajectory_prac_pipreview = true, -- 显示投掷物轨迹
    ammo_grenade_limit_total = 5,                -- 可以购买五颗手雷这样诱饵弹也可以买了
    mp_buytime = 99999999,                       -- 无限购买时间
    sv_infinite_ammo = 1,                        -- 无限子弹及投掷物
    sv_showimpacts = 0,                          -- 显示子弹落点
    cl_showfps = 0,                              -- 显示帧数
    mp_drop_knife_enable = 1,                    -- 允许丢刀
    mp_weapons_glow_on_ground = 1,               -- 武器掉落高亮显示
    cl_follow_grenade_view = 1,                  -- 跟随投掷物
    mp_maxmoney = 16000,                         -- 最大16000金钱
    mp_startmoney = 16000,                       -- 出生金钱为16000
    god = 1,
}

cs2.bind("x", "noclip")                          -- X 键飞行
cs2.bind("j", function()                         -- J 键一键清空道具
    cs2.config {
        "ent_fire hegrenade_projectile kill",    -- 清除抛出的高爆手雷实体
        "ent_fire flashbang_projectile kill",    -- 清除抛出的闪光弹实体，无法清除爆开后的闪白效果
        "ent_fire smokegrenade_projectile kill", -- 清除抛出的烟雾弹实体，烟雾效果是由烟雾弹实体持续释放，可一并清除
        "ent_fire decoy_projectile kill",        -- 清除抛出的诱饵弹实体，枪声效果是由诱饵弹实体持续释放，可一并清除
        "ent_fire molotov_projectile kill",      -- 清除抛出的燃烧瓶实体，无法清除爆开后的火焰效果
        "ent_fire incgrenade_projectile kill",   -- 清除抛出的燃烧弹实体，无法清除爆开后的火焰效果
        "ent_fire inferno kill"                  -- 清除火焰效果
    }
end)
cs2.bind("k", "sv_rethrow_last_grenade") -- 重现服务器内上一个使用过的投掷物
cs2.bind("l", "subclass_create 515") -- 蝴蝶刀

cs2.print("跑图脚本已加载") -- 控制台输出消息
cs2.build() -- 构建 CFG
