--//==================================================
--// 🥔 POTATO SCRIPT — CORE
--//==================================================

local PS = _G.PotatoScript
if not PS then
    warn("[PotatoScript] Core: PotatoScript не загружен")
    return
end

--// СЕРВИСЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

PS.Players = Players
PS.RunService = RunService
PS.TweenService = TweenService
PS.UserInputService = UserInputService
PS.Lighting = Lighting
PS.LocalPlayer = LocalPlayer
PS.Camera = Camera

--// ЦВЕТА
PS.Colors = {
    Background = Color3.fromRGB(14, 15, 19),
    Sidebar = Color3.fromRGB(18, 19, 24),
    Panel = Color3.fromRGB(22, 23, 29),
    Panel2 = Color3.fromRGB(27, 28, 35),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(145, 147, 155),
    Accent = Color3.fromRGB(255, 170, 65),
    AccentDark = Color3.fromRGB(200, 130, 40),
    Green = Color3.fromRGB(70, 210, 125),
    Red = Color3.fromRGB(255, 65, 75),
    Orange = Color3.fromRGB(255, 170, 65)
}
local Colors = PS.Colors

--// PARENT
local Parent
pcall(function()
    if gethui then Parent = gethui() else Parent = game:GetService("CoreGui") end
end)
if not Parent then Parent = game:GetService("CoreGui") end
PS.Parent = Parent

--// CONNECT + CLEANUP
PS.Connections = {}
PS.Cleanup = {}

function PS.Connect(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(PS.Connections, conn)
    return conn
end

function PS.DisconnectAll()
    for _, conn in ipairs(PS.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(PS.Connections)
end

function PS.Track(instance)
    if instance then table.insert(PS.Cleanup, instance) end
    return instance
end

function PS.CleanupAll()
    for _, obj in ipairs(PS.Cleanup) do
        pcall(function() if obj then obj:Destroy() end end)
    end
    table.clear(PS.Cleanup)
end

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PotatoScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Parent
PS.GUI = ScreenGui

--// СОЗДАНИЕ TOGGLE
function PS.CreateToggle(parent, text, order, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 42)
    holder.BackgroundColor3 = Colors.Panel
    holder.BorderSizePixel = 0
    holder.LayoutOrder = math.floor(order or 0)
    holder.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.fromOffset(14, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(42, 22)
    button.Position = UDim2.new(1, -53, 0.5, -11)
    button.BackgroundColor3 = default and Colors.Accent or Colors.Panel2
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = holder

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = button

    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromOffset(16, 16)
    circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3)
    circle.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    circle.BorderSizePixel = 0
    circle.Parent = button

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local state = default

    local function SetState(value)
        state = value
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Colors.Accent or Colors.Panel2
        }):Play()
        TweenService:Create(circle, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3)
        }):Play()
        if callback then pcall(callback, state) end
    end

    PS.Connect(button.MouseButton1Click, function()
        SetState(not state)
    end)

    return { Set = SetState, Get = function() return state end }
end

--// СОЗДАНИЕ SLIDER
function PS.CreateSlider(parent, text, order, min, max, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 55)
    holder.BackgroundColor3 = Colors.Panel
    holder.BorderSizePixel = 0
    holder.LayoutOrder = math.floor(order or 0)
    holder.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 22)
    label.Position = UDim2.fromOffset(14, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.fromOffset(55, 22)
    valueLabel.Position = UDim2.new(1, -67, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Colors.SubText
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = holder

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -28, 0, 5)
    bar.Position = UDim2.fromOffset(14, 37)
    bar.BackgroundColor3 = Colors.Panel2
    bar.BorderSizePixel = 0
    bar.Parent = holder

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local dragging = false
    local value = default

    local function SetValue(v)
        value = math.clamp(v, min, max)
        local percent = (value - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(math.floor(value * 100) / 100)
        if callback then pcall(callback, value) end
    end

    local function Update(input)
        local percent = math.clamp(
            (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0, 1
        )
        SetValue(min + (max - min) * percent)
    end

    PS.Connect(bar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Update(input)
        end
    end)

    PS.Connect(UserInputService.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input)
        end
    end)

    PS.Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    SetValue(default)

    return { Set = SetValue, Get = function() return value end }
end

--// СОЗДАНИЕ SECTION (заголовок)
function PS.CreateSection(parent, title, order)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 30)
    section.BackgroundColor3 = Colors.Panel2
    section.BorderSizePixel = 0
    section.Text = "  " .. title
    section.TextColor3 = Colors.Accent
    section.TextSize = 13
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.LayoutOrder = math.floor(order or 0)
    section.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = section

    return section
end

--// СОЗДАНИЕ PAGE
PS.Pages = {}

function PS.CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, -30, 1, -65)
    page.Position = UDim2.fromOffset(15, 55)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Colors.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = PS.Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    PS.Connect(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    PS.Pages[name] = page
    return page
end

--// MAIN GUI
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(650, 420)
Main.Position = UDim2.new(0.5, -325, 0.5, -210)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
PS.Main = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(42, 44, 53)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, 0)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 14)
SidebarCorner.Parent = Sidebar

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 15, 1, 0)
SidebarFix.Position = UDim2.new(1, -15, 0, 0)
SidebarFix.BackgroundColor3 = Colors.Sidebar
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

--// LOGO
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -20, 0, 35)
Logo.Position = UDim2.fromOffset(15, 16)
Logo.BackgroundTransparency = 1
Logo.Text = "🥔 POTATO"
Logo.TextColor3 = Colors.Accent
Logo.TextSize = 20
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = Sidebar

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, -20, 0, 20)
Version.Position = UDim2.fromOffset(15, 45)
Version.BackgroundTransparency = 1
Version.Text = "Script v1.0"
Version.TextColor3 = Colors.SubText
Version.TextSize = 10
Version.Font = Enum.Font.GothamMedium
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Sidebar

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -145, 1, 0)
Content.Position = UDim2.new(0, 145, 0, 0)
Content.BackgroundTransparency = 1
Content.Parent = Main
PS.Content = Content

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -30, 0, 55)
Header.Position = UDim2.fromOffset(15, 0)
Header.BackgroundTransparency = 1
Header.Parent = Content

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -60, 0, 30)
HeaderTitle.Position = UDim2.fromOffset(5, 12)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "Player"
HeaderTitle.TextColor3 = Colors.Text
HeaderTitle.TextSize = 20
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header
PS.HeaderTitle = HeaderTitle

--// CLOSE
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -32, 0, 10)
Close.BackgroundColor3 = Colors.Panel2
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Colors.SubText
Close.TextSize = 20
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

PS.Connect(Close.MouseButton1Click, function()
    Main.Visible = false
end)

--// СОЗДАЁМ ВКЛАДКИ
PS.CreatePage("Player")
PS.CreatePage("Aim")
PS.CreatePage("World")
PS.CreatePage("Misc")
PS.CreatePage("Settings")
PS.CreatePage("Info")

--// ВКЛАДКИ SIDEBAR
PS.Tabs = {}

function PS.CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.BackgroundColor3 = Colors.AccentDark
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Colors.SubText
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    btn.LayoutOrder = math.floor(order or 0)
    btn.Parent = Sidebar

    -- позиция по LayoutOrder
    local layout = Sidebar:FindFirstChildOfClass("UIListLayout")
    if not layout then
        layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 0)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = Sidebar
    end

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    PS.Tabs[name] = btn

    PS.Connect(btn.MouseButton1Click, function()
        for _, page in pairs(PS.Pages) do page.Visible = false end
        for _, tab in pairs(PS.Tabs) do
            tab.BackgroundTransparency = 1
            tab.TextColor3 = Colors.SubText
        end
        if PS.Pages[name] then PS.Pages[name].Visible = true end
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Colors.Text
        PS.HeaderTitle.Text = name
    end)

    return btn
end

-- Sidebar layout для табов
local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 8)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = Sidebar

-- Паддинг для табов
local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 80)
sidebarPad.PaddingLeft = UDim.new(0, 10)
sidebarPad.PaddingRight = UDim.new(0, 10)
sidebarPad.Parent = Sidebar

PS.CreateTab("Player", 1)
PS.CreateTab("Aim", 2)
PS.CreateTab("World", 3)
PS.CreateTab("Misc", 4)
PS.CreateTab("Settings", 5)
PS.CreateTab("Info", 6)

-- Показываем Player по умолчанию
PS.Pages["Player"].Visible = true
PS.Tabs["Player"].BackgroundTransparency = 0
PS.Tabs["Player"].TextColor3 = Colors.Text

--// ПЕРЕТАСКИВАНИЕ
local dragging = false
local dragStart, startPos

PS.Connect(Header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

PS.Connect(UserInputService.InputChanged, function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
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

--// MENU TOGGLE
local shiftHeld = false

PS.Connect(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    local key = (PS.Config and PS.Config.MenuKey) or Enum.KeyCode.RightShift
    if input.KeyCode == key and not shiftHeld then
        shiftHeld = true
        Main.Visible = not Main.Visible
    end
end)

PS.Connect(UserInputService.InputEnded, function(input)
    local key = (PS.Config and PS.Config.MenuKey) or Enum.KeyCode.RightShift
    if input.KeyCode == key then shiftHeld = false end
end)

--// UNHOOK
function PS.Unhook()
    if not PS.Active then return end
    PS.Active = false

    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end)

    pcall(function() if PS.RestoreRecoil then PS.RestoreRecoil() end end)
    pcall(function() if PS.RestoreLighting then PS.RestoreLighting() end end)
    pcall(function() PS.DisconnectAll() end)
    pcall(function() PS.CleanupAll() end)

    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                for _, obj in ipairs(p.Character:GetChildren()) do
                    if obj.Name:find("Potato") then obj:Destroy() end
                end
            end
        end
    end)

    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:find("Potato") then obj:Destroy() end
        end
    end)

    pcall(function() if PS.GUI then PS.GUI:Destroy() end end)

    _G.PotatoScript = nil
    print("[PotatoScript] Unhooked — всё удалено")
end

print("[PotatoScript] Core загружен")
