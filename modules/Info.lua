--//==================================================
--// 🥔 POTATO SCRIPT — INFO
--//==================================================

local PS = _G.PotatoScript
if not PS then
    warn("[PotatoScript] Info: PotatoScript не загружен")
    return
end

local InfoPage = PS.Pages["Info"]
local Colors = PS.Colors

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.fromOffset(5, 5)
title.BackgroundTransparency = 1
title.Text = "Information"
title.TextColor3 = Colors.Text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = InfoPage

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -10, 0, 200)
info.Position = UDim2.fromOffset(5, 45)
info.BackgroundColor3 = Colors.Panel
info.BorderSizePixel = 0
info.Text = "🥔 POTATO SCRIPT\n\n" ..
    "Version: 1.0.0\n" ..
    "Author: SeregaRQ\n" ..
    "Game: Project Delta\n\n" ..
    "Menu Toggle: Right Shift\n" ..
    "Aimbot: RMB Hold"
info.TextColor3 = Colors.SubText
info.TextSize = 13
info.Font = Enum.Font.GothamMedium
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Parent = InfoPage

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = info

local infoPad = Instance.new("UIPadding")
infoPad.PaddingTop = UDim.new(0, 15)
infoPad.PaddingLeft = UDim.new(0, 15)
infoPad.Parent = info

print("[PotatoScript] Info загружен")
