--//==================================================
--// 🥔 POTATO SCRIPT — MISC
--//==================================================

local PS = _G.PotatoScript
if not PS then
    warn("[PotatoScript] Misc: PotatoScript не загружен")
    return
end

local MiscPage = PS.Pages["Misc"]
local Colors = PS.Colors
local Players = PS.Players
local LocalPlayer = PS.LocalPlayer
local Camera = PS.Camera
local RunService = PS.RunService
local UserInputService = PS.UserInputService
local Lighting = PS.Lighting

--//==================================================
--// НАСТРОЙКИ
--//==================================================

PS.Misc = PS.Misc or {}
local M = PS.Misc

M.Watermark       = M.Watermark or false
M.InventoryViewer = M.InventoryViewer or true
M.TargetHUD       = M.TargetHUD or true
M.InventoryDist   = M.InventoryDist or 500

--//==================================================
--// ЗАГОЛОВОК
--//==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.BackgroundTransparency = 1
title.Text = "Miscellaneous"
title.TextColor3 = Colors.Text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.LayoutOrder = 0
title.Parent = MiscPage

--//==================================================
--// UI
--//==================================================

PS.CreateToggle(MiscPage, "Watermark", 10, M.Watermark, function(v)
    M.Watermark = v
    if PS.WatermarkGui then
        PS.WatermarkGui.Enabled = v
    end
end)

PS.CreateToggle(MiscPage, "Inventory Viewer", 20, M.InventoryViewer, function(v)
    M.InventoryViewer = v
end)

PS.CreateToggle(MiscPage, "Target HUD", 30, M.TargetHUD, function(v)
    M.TargetHUD = v
end)

PS.CreateSlider(MiscPage, "Inventory Distance", 40, 50, 3000, M.InventoryDist, function(v)
    M.InventoryDist = v
end)

--//==================================================
--// WATERMARK
--//==================================================

local wmGui = Instance.new("ScreenGui")
wmGui.Name = "PotatoWatermark"
wmGui.ResetOnSpawn = false
wmGui.IgnoreGuiInset = true
wmGui.Enabled = M.Watermark
wmGui.Parent = PS.Parent
PS.Track(wmGui)
PS.WatermarkGui = wmGui

local wm = Instance.new("Frame")
wm.Size = UDim2.fromOffset(420, 132)
wm.Position = UDim2.fromOffset(18, 18)
wm.BackgroundColor3 = Color3.fromRGB(9, 12, 18)
wm.BackgroundTransparency = 0.04
wm.BorderSizePixel = 0
wm.Parent = wmGui

local wmCorner = Instance.new("UICorner")
wmCorner.CornerRadius = UDim.new(0, 10)
wmCorner.Parent = wm

local wmStroke = Instance.new("UIStroke")
wmStroke.Color = Color3.fromRGB(65, 85, 130)
wmStroke.Thickness = 1
wmStroke.Transparency = 0.25
wmStroke.Parent = wm

-- Top accent
local accent = Instance.new("Frame")
accent.Size = UDim2.new(1, 0, 0, 2)
accent.BackgroundColor3 = Color3.fromRGB(255, 170, 65)
accent.BorderSizePixel = 0
accent.Parent = wm

-- Header
local wmTitle = Instance.new("TextLabel")
wmTitle.Size = UDim2.fromOffset(90, 25)
wmTitle.Position = UDim2.fromOffset(14, 9)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "🥔 POTATO"
wmTitle.TextColor3 = Color3.fromRGB(255, 170, 65)
wmTitle.TextSize = 16
wmTitle.Font = Enum.Font.GothamBlack
wmTitle.TextXAlignment = Enum.TextXAlignment.Left
wmTitle.Parent = wm

local wmUser = Instance.new("TextLabel")
wmUser.Size = UDim2.fromOffset(240, 20)
wmUser.Position = UDim2.fromOffset(122, 10)
wmUser.BackgroundTransparency = 1
wmUser.Text = LocalPlayer.Name
wmUser.TextColor3 = Color3.fromRGB(225, 230, 245)
wmUser.TextSize = 13
wmUser.Font = Enum.Font.GothamBold
wmUser.TextXAlignment = Enum.TextXAlignment.Left
wmUser.Parent = wm

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -28, 0, 1)
divider.Position = UDim2.fromOffset(14, 43)
divider.BackgroundColor3 = Color3.fromRGB(32, 38, 52)
divider.BorderSizePixel = 0
divider.Parent = wm

-- Stat creator
local function CreateStat(parent, x, y, label, value)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.fromOffset(122, 32)
    holder.Position = UDim2.fromOffset(x, y)
    holder.Parent = parent

    local labelObj = Instance.new("TextLabel")
    labelObj.Size = UDim2.fromOffset(122, 12)
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = Color3.fromRGB(90, 100, 120)
    labelObj.TextSize = 8
    labelObj.Font = Enum.Font.GothamBold
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.Parent = holder

    local valueObj = Instance.new("TextLabel")
    valueObj.Size = UDim2.fromOffset(122, 18)
    valueObj.Position = UDim2.fromOffset(0, 11)
    valueObj.BackgroundTransparency = 1
    valueObj.Text = value
    valueObj.TextColor3 = Color3.fromRGB(205, 215, 235)
    valueObj.TextSize = 11
    valueObj.Font = Enum.Font.GothamMedium
    valueObj.TextXAlignment = Enum.TextXAlignment.Left
    valueObj.Parent = holder

    return valueObj
end

local fpsLabel     = CreateStat(wm, 14, 51, "PERFORMANCE", "0 FPS")
local pingLabel    = CreateStat(wm, 145, 51, "NETWORK", "0 MS")
local timeLabel    = CreateStat(wm, 276, 51, "TIME", "00:00:00")
local dateLabel    = CreateStat(wm, 14, 86, "DATE", "---")
local serverLabel  = CreateStat(wm, 145, 86, "SERVER", "EU")
local uptimeLabel  = CreateStat(wm, 276, 86, "UPTIME", "00:00:00")

local playersLabel = Instance.new("TextLabel")
playersLabel.Size = UDim2.fromOffset(100, 16)
playersLabel.Position = UDim2.fromOffset(14, 112)
playersLabel.BackgroundTransparency = 1
playersLabel.Text = "PLAYERS  0"
playersLabel.TextColor3 = Color3.fromRGB(110, 120, 140)
playersLabel.TextSize = 8
playersLabel.Font = Enum.Font.GothamBold
playersLabel.TextXAlignment = Enum.TextXAlignment.Left
playersLabel.Parent = wm

local positionLabel = Instance.new("TextLabel")
positionLabel.Size = UDim2.fromOffset(280, 16)
positionLabel.Position = UDim2.fromOffset(125, 112)
positionLabel.BackgroundTransparency = 1
positionLabel.Text = "POS  0, 0, 0"
positionLabel.TextColor3 = Color3.fromRGB(110, 120, 140)
positionLabel.TextSize = 8
positionLabel.Font = Enum.Font.GothamBold
positionLabel.TextXAlignment = Enum.TextXAlignment.Left
positionLabel.Parent = wm

-- Dragging watermark
do
    local dragging, dragStart, startPos
    PS.Connect(wm.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = wm.Position
        end
    end)
    PS.Connect(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            wm.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    PS.Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Watermark data
local wmStartTime = tick()
local wmFrameCount = 0
local wmLastFPSCheck = tick()

local function FormatTime(s)
    s = math.max(0, math.floor(s))
    local h = math.floor(s / 3600)
    local m = math.floor((s % 3600) / 60)
    local sec = s % 60
    return string.format("%02d:%02d:%02d", h, m, sec)
end

local function GetPing()
    local ping = 0
    pcall(function()
        ping = math.round(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    return ping
end

PS.Connect(RunService.RenderStepped, function()
    if not PS.Active then return end
    if not M.Watermark then return end

    local now = tick()
    wmFrameCount = wmFrameCount + 1

    if now - wmLastFPSCheck >= 1 then
        local elapsed = now - wmLastFPSCheck
        local fps = math.round(wmFrameCount / elapsed)
        wmFrameCount = 0
        wmLastFPSCheck = now

        fpsLabel.Text = tostring(fps) .. " FPS"
        pingLabel.Text = tostring(GetPing()) .. " MS"
        timeLabel.Text = os.date("%H:%M:%S")
        dateLabel.Text = os.date("%b %d %Y")
        serverLabel.Text = "EU"
        uptimeLabel.Text = FormatTime(now - wmStartTime)
        playersLabel.Text = "PLAYERS  " .. tostring(#Players:GetPlayers())

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local p = root.Position
            positionLabel.Text = string.format("POS  %d, %d, %d",
                math.round(p.X), math.round(p.Y), math.round(p.Z))
        else
            positionLabel.Text = "POS  -, -, -"
        end
    end
end)

--//==================================================
--// INVENTORY VIEWER + TARGET HUD
--//==================================================

local ValueCache = {
    ["6B45"] = 16, ["AS Val"] = 16, ["ATC Key"] = 4, ["Airfield Key"] = 6, ["Altyn"] = 16,
    ["Altyn Visor"] = 8, ["Attak-5 60L"] = 16, ["Bolts"] = 1, ["Crane Key"] = 6, ["DAGR"] = 8,
    ["Duct Tape"] = 1, ["Fast MT"] = 10, ["Flare Gun"] = 8, ["Fueling Station Key"] = 4,
    ["Garage Key"] = 4, ["Hammer"] = 1, ["JPC"] = 10, ["Lighthouse Key"] = 6, ["M4A1"] = 12,
    ["Nails"] = 1, ["Nuts"] = 1, ["Saiga 12"] = 8, ["Super Glue"] = 1, ["Village Key"] = 4, ["Wrench"] = 1
}

-- Кэш иконок
local ItemIcons = {}

task.spawn(function()
    local RS = game:GetService("ReplicatedStorage")
    for _, container in ipairs({ RS:FindFirstChild("ItemsList"), RS:FindFirstChild("ItemsListModels") }) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                local props = obj:FindFirstChild("ItemProperties")
                if props then
                    local icon = props:FindFirstChild("ItemIcon")
                    if icon and (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) then
                        ItemIcons[obj.Name] = icon.Image
                        local cs = props:GetAttribute("CallSign")
                        if cs then ItemIcons[tostring(cs)] = icon.Image end
                    end
                end
            end
        end
    end
end)

local function GetEquippedItem(char)
    if not char then return "None" end
    local holdingObj = char:FindFirstChild("Holding")
    if holdingObj and holdingObj:IsA("ObjectValue") and holdingObj.Value then
        local item = holdingObj.Value
        local props = item:FindFirstChild("ItemProperties")
        if props then
            local cs = props:GetAttribute("CallSign") or props:GetAttribute("ItemName")
            if cs then return tostring(cs) end
        end
        return item.Name
    end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then return tool.Name end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Model") and (c:FindFirstChild("ItemProperties") or c:FindFirstChild("Handle")) then
            local props = c:FindFirstChild("ItemProperties")
            if props then
                local cs = props:GetAttribute("CallSign") or props:GetAttribute("ItemName")
                if cs then return tostring(cs) end
            end
            return c.Name
        end
    end
    return "None"
end

local function ScanInventory(targetPlayer)
    local items = {}
    local RS = game:GetService("ReplicatedStorage")
    local rsPlayers = RS:FindFirstChild("Players")
    local pFolder = rsPlayers and rsPlayers:FindFirstChild(targetPlayer.Name)
    local invFolder = pFolder and pFolder:FindFirstChild("Inventory")
    if invFolder then
        for _, item in ipairs(invFolder:GetChildren()) do
            local props = item:FindFirstChild("ItemProperties")
            local name = (props and tostring(props:GetAttribute("CallSign") or props:GetAttribute("ItemName"))) or item.Name
            if not table.find(items, name) then
                table.insert(items, name)
            end
        end
    end
    local char = targetPlayer.Character
    if char then
        local held = GetEquippedItem(char)
        if held ~= "None" and not table.find(items, held) then
            table.insert(items, held)
        end
    end
    return items
end

-- GUI инвентаря
local invGui = Instance.new("ScreenGui")
invGui.Name = "PotatoInventoryViewer"
invGui.ResetOnSpawn = false
invGui.IgnoreGuiInset = true
invGui.Parent = PS.Parent
PS.Track(invGui)

local invFrame = Instance.new("Frame")
invFrame.Size = UDim2.new(0, 185, 0, 220)
invFrame.Position = UDim2.new(0.5, 220, 0.5, -110)
invFrame.BackgroundColor3 = Colors.Panel
invFrame.BorderSizePixel = 0
invFrame.Visible = false
invFrame.Parent = invGui

local invCorner = Instance.new("UICorner")
invCorner.CornerRadius = UDim.new(0, 8)
invCorner.Parent = invFrame

local invStroke = Instance.new("UIStroke")
invStroke.Color = Colors.Accent
invStroke.Thickness = 1
invStroke.Parent = invFrame

local invTitle = Instance.new("Frame")
invTitle.Size = UDim2.new(1, 0, 0, 26)
invTitle.BackgroundColor3 = Colors.Panel2
invTitle.BorderSizePixel = 0
invTitle.Parent = invFrame

local invTitleCorner = Instance.new("UICorner")
invTitleCorner.CornerRadius = UDim.new(0, 8)
invTitleCorner.Parent = invTitle

local invTitleLabel = Instance.new("TextLabel")
invTitleLabel.Size = UDim2.new(1, -10, 1, 0)
invTitleLabel.Position = UDim2.new(0, 8, 0, 0)
invTitleLabel.BackgroundTransparency = 1
invTitleLabel.Text = "TARGET INFO"
invTitleLabel.TextColor3 = Colors.Text
invTitleLabel.TextSize = 12
invTitleLabel.Font = Enum.Font.GothamBold
invTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
invTitleLabel.Parent = invTitle

local invHP = Instance.new("TextLabel")
invHP.Size = UDim2.new(1, -10, 0, 16)
invHP.Position = UDim2.new(0, 8, 0, 30)
invHP.BackgroundTransparency = 1
invHP.Text = "HP: 100/100"
invHP.TextColor3 = Colors.SubText
invHP.TextSize = 12
invHP.Font = Enum.Font.GothamMedium
invHP.TextXAlignment = Enum.TextXAlignment.Left
invHP.Parent = invFrame

local invTool = Instance.new("TextLabel")
invTool.Size = UDim2.new(1, -10, 0, 16)
invTool.Position = UDim2.new(0, 8, 0, 46)
invTool.BackgroundTransparency = 1
invTool.Text = "Tool: None"
invTool.TextColor3 = Colors.SubText
invTool.TextSize = 12
invTool.Font = Enum.Font.GothamMedium
invTool.TextXAlignment = Enum.TextXAlignment.Left
invTool.Parent = invFrame

local invSpeed = Instance.new("TextLabel")
invSpeed.Size = UDim2.new(1, -10, 0, 16)
invSpeed.Position = UDim2.new(0, 8, 0, 62)
invSpeed.BackgroundTransparency = 1
invSpeed.Text = "SPD: 0 | DIST: 0"
invSpeed.TextColor3 = Colors.SubText
invSpeed.TextSize = 12
invSpeed.Font = Enum.Font.GothamMedium
invSpeed.TextXAlignment = Enum.TextXAlignment.Left
invSpeed.Parent = invFrame

local invScroll = Instance.new("ScrollingFrame")
invScroll.Size = UDim2.new(1, -10, 1, -90)
invScroll.Position = UDim2.new(0, 5, 0, 85)
invScroll.BackgroundTransparency = 1
invScroll.BorderSizePixel = 0
invScroll.ScrollBarThickness = 2
invScroll.ScrollBarImageColor3 = Colors.Accent
invScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
invScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
invScroll.Parent = invFrame

local invGrid = Instance.new("UIGridLayout")
invGrid.CellPadding = UDim2.new(0, 4, 0, 4)
invGrid.CellSize = UDim2.new(0, 36, 0, 36)
invGrid.Parent = invScroll

-- Dragging inventory
do
    local dragging, dragStart, startPos
    PS.Connect(invTitle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = invFrame.Position
        end
    end)
    PS.Connect(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            invFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    PS.Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Update inventory
local lastTarget = nil
local lastItems = ""

PS.Connect(RunService.Heartbeat, function()
    if not PS.Active then return end
    if not M.InventoryViewer and not M.TargetHUD then
        invFrame.Visible = false
        return
    end

    -- Ищем ближайшего игрока в FOV-круге
    local closestPlayer = nil
    local closestDist = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    -- Берём FOV-радиус из Aimbot
    local fovRadius = (PS.Aim and PS.Aim.FOV) or 180

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    -- Только если игрок в пределах FOV-круга
                    if dist < fovRadius and dist < M.InventoryDist then
                        if dist < closestDist then
                            closestDist = dist
                            closestPlayer = p
                        end
                    end
                end
            end
        end
    end

    if not closestPlayer or not closestPlayer.Character then
        invFrame.Visible = false
        lastTarget = nil
        return
    end

    local char = closestPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then
        invFrame.Visible = false
        return
    end

    invFrame.Visible = true
    invTitleLabel.Text = "TARGET: " .. closestPlayer.Name:upper()

    invHP.Text = string.format("HP: %d / %d", math.round(hum.Health), math.round(hum.MaxHealth))
    invHP.TextColor3 = hum.Health > 60 and Colors.Green or (hum.Health > 30 and Colors.Orange or Colors.Red)

    invTool.Text = "Tool: " .. GetEquippedItem(char)

    local spd = (root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
    local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
    invSpeed.Text = string.format("SPD: %d | DIST: %d", math.round(spd), math.round(dist))

    -- Inventory
    local items = ScanInventory(closestPlayer)
    local itemsKey = table.concat(items, ",")
    if itemsKey ~= lastItems or closestPlayer ~= lastTarget then
        lastItems = itemsKey
        lastTarget = closestPlayer
        for _, c in ipairs(invScroll:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        for _, itemName in ipairs(items) do
            local card = Instance.new("Frame")
            card.BackgroundColor3 = Colors.Panel2
            card.BorderSizePixel = 0
            card.Parent = invScroll

            local cStr = Instance.new("UIStroke")
            cStr.Color = Colors.Accent
            cStr.Thickness = 1
            cStr.Transparency = 0.5
            cStr.Parent = card

            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(1, -4, 1, -4)
            icon.Position = UDim2.new(0.5, 0, 0.5, 0)
            icon.AnchorPoint = Vector2.new(0.5, 0.5)
            icon.BackgroundTransparency = 1
            icon.Image = ItemIcons[itemName] or "rbxassetid://1316045217"
            icon.Parent = card
        end
    end
end)

print("[PotatoScript] Misc загружен")
