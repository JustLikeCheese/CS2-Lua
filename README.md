# CS2-Script

一个简单的 Lua CS2 CFG 绑定

A simple lua binding for Counter-Strike 2.

## 为什么用 CS2-Script Why CS2-Script?

Lua 脚本比 CFG 具有更高的可读性, 并且 Lua 的语法, 让 CFG 更加容易编写。并且 CS2-Script 支持指定编译 CFG 时输出单行。

Lua script has a higher readability than CFG, and the syntax of Lua makes CFG easier to write. And CS2-Script supports specifying the output of a single line when compiling CFG.

## 教程 Tutorial

### 测试脚本 Run Script

```sh
lua54 ..\test\practice\main.lua output.cfg 1
```

### 导入库 Import Library

```lua
require "cs2"
```

### cs2.build

在脚本末尾添加 `cs2.build()` 以触发 CS2-Script 构建

In the end of your script, add `cs2.build()` to trigger CS2-Script build

### cs2.config

加载 CFG 配置。可以为 function、table 和 string。

Load cfg config. The value can be function, table or string.

```lua
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
```

```lua
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
    cl_follow_grenade_view = 1                   -- 跟随投掷物
}
```

```lua
cs2.build()
```

### cs2.bind

绑定某个按键飞行 Bind a key to fly

```lua
cs2.bind("x", "noclip")
```

当然也可以为 function

```lua
function 
```

### cs2.clear

清除控制台输出 Clear console output

```lua
cs2.clear()
```

### cs2.print && cs2.println

在控制台输出信息 Print message to console

```lua
cs2.print("Hello World!")
cs2.println("你好世界")
```

### cs2.run

运行命令 Run command

```lua
cs2.run("mp_buy_anywhere 1")
cs2.run("mp_buytime 999999999")
```

### cs2.exec

运行 CFG 文件 Run cfg file

```lua
cs2.exec("cfg/example.cfg")
```

## 例子 Example

[练习 Lua 脚本例子](https://github.com/JustLikeCheese/CS2-Lua/blob/master/test/practice/main.lua)
