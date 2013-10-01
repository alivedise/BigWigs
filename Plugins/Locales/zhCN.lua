local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "zhCN")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "风格"
L.bigWigsBarStyleName_Default = "默认"

L["Clickable Bars"] = "可点击计时条"
L.clickableBarsDesc = "Big Wigs 计时条预设是点击穿越的。这样可以选择目标或使用 AoE 法术攻击物体，更改镜头角度等等，当鼠标指针划过计时条。|cffff4411如果启用可点击计时条，这些将不能实现。|r计时条将拦截任何鼠标点击并阻止相应功能。\n"
L["Enables bars to receive mouse clicks."] = "启用计时条接受点击。"
L["Modifier"] = "修改"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "按住选定的修改键以启用计时条点击操作。"
L["Only with modifier key"] = "只与修改键配合"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "除非修改键被按下否则允许计时条点击穿越，此时鼠标以下动作可用。"

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "临时超级醒目计时条及任何信息的持续时间。"
L["Report"] = "报告"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "向当前的频道报告计时条信息。可用频道包括副本、团队、小队、普通，自动选择最适频道。"
L["Remove"] = "移除"
L["Temporarily removes the bar and all associated messages."] = "临时移除计时条和全部相关信息。"
L["Remove other"] = "移除其它"
L["Temporarily removes all other bars (except this one) and associated messages."] = "临时移除所有计时条（除此之外）和全部相关信息。"
L.disable = "禁用"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "永久禁用此首领战斗技能计时条选项。"

L["Emphasize at... (seconds)"] = "…（秒）后醒目"
L["Scale"] = "缩放"
L["Grow upwards"] = "向上成长"
L["Toggle bars grow upwards/downwards from anchor."] = "切换计时条在锚点向上或向下成长。"
L["Texture"] = "材质"
L["Emphasize"] = "醒目"
L["Enable"] = "启用"
L["Move"] = "移动"
L.moveDesc = "移动醒目计时条到醒目锚点。如此选项关闭，醒目计时条将只简单的改变缩放和颜色。"
L["Regular bars"] = "常规计时条"
L["Emphasized bars"] = "醒目计时条"
L["Align"] = "对齐"
L["Left"] = "左"
L["Center"] = "中"
L["Right"] = "右"
L["Time"] = "时间"
L["Whether to show or hide the time left on the bars."] = "在计时条上显示或隐藏时间。"
L["Icon"] = "图标"
L["Shows or hides the bar icons."] = "显示或隐藏计时条图标。"
L.font = "字体"
L["Restart"] = "重新加载"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "重新加载醒目计时条并从10开始倒数。"
L["Fill"] = "填充"
L["Fills the bars up instead of draining them."] = "填充计时条而不是显示为空。"

L["Local"] = "本地"
L["%s: Timer [%s] finished."] = "%s：计时条[%s]到时间。"
L["Custom bar '%s' started by %s user %s."] = "自定义计时条“%s”由%s玩家%s发起。"

L["Pull"] = "拉怪"
L["Pulling!"] = "拉怪中！"
L["Pull timer started by %s user %s."] = "拉怪由%s玩家%s发起的计时器。"
L["Pull in %d sec"] = "%d秒后拉怪"
L["Sending a pull timer to Big Wigs and DBM users."] = "正在发送一个拉怪计时器到 Big Wigs 和 DBM 玩家。"
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "正在发送自定义计时条“%s”到 Big Wigs 和 DBM 玩家。"
L["This function requires raid leader or raid assist."] = "此功能需要团队领袖或助理权限。"
L["Must be between 1 and 60. A correct example is: /pull 5"] = "必须位于1到60之间。正确用法：/pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "错误格式。正确用法：/raidbar 20 文本"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "指定了无效的时间。 <时间>可以是一个以秒为单位，一个分:秒一对，或分秒。例如，1:20或2M。"
L["This function can't be used during an encounter."] = "此功能在战斗中不能使用。"
L["Pull timer cancelled by %s."] = "%s取消了拉怪计时器。"

L.customBarSlashPrint = "此功能已被重新命名。使用 /raidbar 发送自定义计时条到团队或使用 /localbar 只有自身可见计时条。"

-----------------------------------------------------------------------
-- Colors.lua
--

L.Colors = "颜色"

L.Messages = "信息"
L.Bars = "计时条"
L.Background = "背景"
L.Text = "文本"
L.TextShadow = "文本阴影"
L.Flash = "闪烁"
L.Normal = "标准"
L.Emphasized = "醒目"

L.Reset = "重置"
L["Resets the above colors to their defaults."] = "重置以上颜色为默认。"
L.resetAll = "重置所有"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "如果为首领战斗自定义了颜色设置，这个按钮将重置替换“所有”颜色为默认。"

L.Important = "重要"
L.Personal = "个人"
L.Urgent = "紧急"
L.Attention = "注意"
L.Positive = "积极"
L.Neutral = "中性"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "超级醒目"
L.superEmphasizeDesc = "相关信息或特定首领战斗技能计时条增强。\n\n在这里设置当开启超级醒目位于首领战斗技能高级选项时所应该发生的事件。\n\n|cffff4411注意：超级醒目功能默认情况下所有技能关闭。|r\n"
L["UPPERCASE"] = "大写"
L["Uppercases all messages related to a super emphasized option."] = "所有超级醒目选项相关信息大写。"
L["Double size"] = "双倍尺寸"
L["Doubles the size of super emphasized bars and messages."] = "超级醒目计时条和信息双倍尺寸。"
L["Countdown"] = "冷却"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "如果相关的计时器的长度超过5秒，一个声音与视觉将增加倒计时的最后5秒。想象某个倒计时\"5... 4... 3... 2... 1... 冷却！\"和大个数字位于屏幕中间。"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "向外通过 Big Wigs 插件信息显示。这些包含了图标，颜色和在同一时间在屏幕上的显示4条信息。新的信息将再一次快速的放大和缩小来提醒用户。新插入的信息将增大并立即缩小提醒用户注意。"
L.emphasizedSinkDescription = "通过此插件输出到 Big Wigs 醒目信息显示。此显示支持文本和颜色，每次只可显示一条信息。"
L.emphasizedCountdownSinkDescription = "路线输出从此插件通过 Big Wigs 醒目冷却信息显示。此显示支持文本和颜色，一次只能显示一个消息。"

L["Big Wigs Emphasized"] = "Big Wigs 醒目"
L["Messages"] = "信息"
L["Normal messages"] = "一般信息"
L["Emphasized messages"] = "醒目信息"
L["Output"] = "输出"
L["Emphasized countdown"] = "醒目冷却"

L["Use colors"] = "使用彩色信息"
L["Toggles white only messages ignoring coloring."] = "选择是否只发送单色信息。"

L["Use icons"] = "使用图标"
L["Show icons next to messages, only works for Raid Warning."] = "显示图标，只能使用在团队警告频道。"

L["Class colors"] = "职业颜色"
L["Colors player names in messages by their class."] = "使用职业颜色来染色信息内玩家颜色。"

L.fontSize = "字体大小"
L["None"] = "无"
L["Thin"] = "细"
L["Thick"] = "粗"
L["Outline"] = "轮廓"
L["Monochrome"] = "单一颜色"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "在全部信息切换为单一颜色，移除全部字体边缘平滑。"
L["Font color"] = "字体颜色"

L["Display time"] = "显示时间"
L["How long to display a message, in seconds"] = "以秒计信息显示时间。"
L["Fade time"] = "消退时间"
L["How long to fade out a message, in seconds"] = "以秒计信息消退时间。"



-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="zhCN", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

