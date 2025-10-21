# CS2-Script

一个简单的 Lua CS2 CFG 绑定

A simple lua binding for Counter-Strike 2.

## 为什么用 CS2-Script Why CS2-Script?

Lua 脚本比 CFG 具有更高的可读性, 并且 Lua 的语法, 让 CFG 更加容易编写。并且 CS2-Script 支持指定编译 CFG 时输出单行。

## 教程 Tutorial

### 测试脚本

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

```lua
cs2.build()
```

### cs2.bind

绑定某个按键飞行 Bind a key to fly

```lua
cs2.bind("x", "noclip")
```

### cs2.clear

清除控制台输出 Clear console output

```lua
cs2.clear()
```

### 控制台输出

## 例子 Example

[练习 Lua 脚本例子](https://github.com/JustLikeCheese/CS2-Lua/blob/master/test/practice/main.lua)
