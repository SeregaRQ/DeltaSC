--//==================================================
--// 🥔 POTATO SCRIPT — SETTINGS
--//==================================================

local PS = _G.PotatoScript
if not PS then
    warn("[PotatoScript] Settings: PotatoScript не загружен")
    return
end

local SettingsPage = PS.Pages["Settings"]
local Colors = PS.Colors
local UserInputService = PS.UserInputService

--// Заголовок

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.fromOffset(5, 5)
title.BackgroundTransparency = 1
title.Text = "Settings"
title.TextColor3 = Colors.Text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = SettingsPage

--// Menu Keybind

PS.Config = PS.Config or {}
PS.Config.MenuKey = PS.Config.MenuKey or Enum.KeyCode.RightShift

local kbHolder = Instance.new("Frame")
kbHolder.Size = UDim2.new(1, -10, 0, 42)
kbHolder.Position = UDim2.fromOffset(5, 45)
kbHolder.BackgroundColor3 = Colors.Panel
kbHolder.BorderSizePixel = 0
kbHolder.Parent = SettingsPage

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 9)
kbCorner.Parent = kbHolder

local kbLabel = Instance.new("TextLabel")
kbLabel.Size = UDim2.new(1, -100, 1, 0)
kbLabel.Position = UDim2.fromOffset(14, 0)
kbLabel.BackgroundTransparency = 1
kbLabel.Text = "Menu Keybind"
kbLabel.TextColor3 = Colors.Text
kbLabel.TextSize = 13
kbLabel.Font = Enum.Font.GothamMedium
kbLabel.TextXAlignment = Enum.TextXAlignment.Left
kbLabel.Parent = kbHolder

local kbBtn = Instance.new("TextButton")
kbBtn.Size = UDim2.fromOffset(80, 26)
kbBtn.Position = UDim2.new(1, -90, 0.5, -13)
kbBtn.BackgroundColor3 = Colors.Panel2
kbBtn.BorderSizePixel = 0
kbBtn.Text = PS.Config.MenuKey.Name
kbBtn.TextColor3 = Colors.Accent
kbBtn.TextSize = 12
kbBtn.Font = Enum.Font.GothamBold
kbBtn.AutoButtonColor = false
kbBtn.Parent = kbHolder

local kbBtnCorner = Instance.new("UICorner")
kbBtnCorner.CornerRadius = UDim.new(0, 6)
kbBtnCorner.Parent = kbBtn

local listening = false

PS.Connect(kbBtn.MouseButton1Click, function()
    listening = true
    kbBtn.Text = "..."
    kbBtn.TextColor3 = Colors.Orange
end)

PS.Connect(UserInputService.InputBegan, function(input, processed)
    if not listening then return end
    if processed then return end
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        PS.Config.MenuKey = input.KeyCode
        kbBtn.Text = input.KeyCode.Name
        kbBtn.TextColor3 = Colors.Accent
        listening = false
    end
end)

--// Unhook

local unhookBtn = Instance.new("TextButton")
unhookBtn.Size = UDim2.new(1, -10, 0, 42)
unhookBtn.Position = UDim2.fromOffset(5, 100)
unhookBtn.BackgroundColor3 = Color3.fromRGB(45, 22, 25)
unhookBtn.BorderSizePixel = 0
unhookBtn.Text = "UNHOOK"
unhookBtn.TextColor3 = Colors.Red
unhookBtn.TextSize = 13
unhookBtn.Font = Enum.Font.GothamBold
unhookBtn.AutoButtonColor = false
unhookBtn.Parent = SettingsPage

local unhookCorner = Instance.new("UICorner")
unhookCorner.CornerRadius = UDim.new(0, 9)
unhookCorner.Parent = unhookBtn

PS.Connect(unhookBtn.MouseButton1Click, function()
    if PS.Unhook then
        PS.Unhook()
    end
end)

print("[PotatoScript] Settings загружен")
