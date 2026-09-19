--//==================================================
--// DeltaSC - GUI
--//==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

--//==================================================
--// CLEAN OLD GUI
--//==================================================

pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("DeltaSC")
    if old then
        old:Destroy()
    end
end)

--//==================================================
--// SERVICES / PARENT
--//==================================================

local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaSC"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

--//==================================================
--// MAIN
--//==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(720, 470)
Main.Position = UDim2.new(0.5, -360, 0.5, -235)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(45, 45, 55)
Stroke.Thickness = 1
Stroke.Transparency = 0.35
Stroke.Parent = Main

--//==================================================
--// TOP BAR
--//==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 58)
TopBar.BackgroundTransparency = 1
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.fromOffset(220, 30)
Title.Position = UDim2.fromOffset(20, 10)
Title.BackgroundTransparency = 1
Title.Text = "DeltaSC"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.fromOffset(250, 18)
Subtitle.Position = UDim2.fromOffset(21, 34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Control Suite"
Subtitle.TextColor3 = Color3.fromRGB(125, 125, 140)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

--//==================================================
--// STATUS
--//==================================================

local Status = Instance.new("Frame")
Status.Name = "Status"
Status.Size = UDim2.fromOffset(105, 30)
Status.Position = UDim2.new(1, -125, 0, 14)
Status.BackgroundColor3 = Color3.fromRGB(22, 42, 30)
Status.BorderSizePixel = 0
Status.Parent = TopBar

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = Status

local StatusDot = Instance.new("TextLabel")
StatusDot.Size = UDim2.fromOffset(20, 20)
StatusDot.Position = UDim2.fromOffset(8, 5)
StatusDot.BackgroundTransparency = 1
StatusDot.Text = "●"
StatusDot.TextColor3 = Color3.fromRGB(80, 220, 120)
StatusDot.TextSize = 12
StatusDot.Font = Enum.Font.GothamBold
StatusDot.Parent = Status

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.fromOffset(70, 25)
StatusText.Position = UDim2.fromOffset(27, 2)
StatusText.BackgroundTransparency = 1
StatusText.Text = "ONLINE"
StatusText.TextColor3 = Color3.fromRGB(145, 235, 165)
StatusText.TextSize = 11
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = Status

--//==================================================
--// SIDEBAR
--//==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 165, 1, -78)
Sidebar.Position = UDim2.fromOffset(12, 66)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 11)
SidebarCorner.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

--//==================================================
--// CONTENT
--//==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -190, 1, -78)
Content.Position = UDim2.fromOffset(178, 66)
Content.BackgroundTransparency = 1
Content.Parent = Main

--//==================================================
--// PAGE SYSTEM
--//==================================================

local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("Frame")
    Page.Name = name
    Page.Size = UDim2.fromScale(1, 1)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Content

    Pages[name] = Page

    return Page
end

local Home = CreatePage("Home")
local Aim = CreatePage("Aim")
local ESP = CreatePage("ESP")
local Misc = CreatePage("Misc")
local Settings = CreatePage("Settings")
local Info = CreatePage("Info")

--//==================================================
--// PAGE TITLE
--//==================================================

local function PageTitle(parent, title, description)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 32)
    Label.Position = UDim2.fromOffset(10, 8)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.TextColor3 = Color3.fromRGB(245, 245, 250)
    Label.TextSize = 22
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -20, 0, 25)
    Description.Position = UDim2.fromOffset(10, 39)
    Description.BackgroundTransparency = 1
    Description.Text = description
    Description.TextColor3 = Color3.fromRGB(120, 120, 135)
    Description.TextSize = 12
    Description.Font = Enum.Font.GothamMedium
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = parent
end

PageTitle(Home, "Welcome", "DeltaSC control panel")
PageTitle(Aim, "Aim", "Aim configuration")
PageTitle(ESP, "ESP", "Visual configuration")
PageTitle(Misc, "Misc", "Additional features")
PageTitle(Settings, "Settings", "Interface settings")
PageTitle(Info, "Info", "DeltaSC information")

--//==================================================
--// NAVIGATION
--//==================================================

local Buttons = {}

local function CreateNavButton(name, text, order)

    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(150, 150, 165)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamSemibold
    Button.LayoutOrder = order
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    Buttons[name] = Button

    return Button
end

local HomeButton = CreateNavButton("Home", "Home", 1)
local AimButton = CreateNavButton("Aim", "Aim", 2)
local ESPButton = CreateNavButton("ESP", "ESP", 3)
local MiscButton = CreateNavButton("Misc", "Misc", 4)
local SettingsButton = CreateNavButton("Settings", "Settings", 5)
local InfoButton = CreateNavButton("Info", "Info", 6)

--//==================================================
--// PAGE SWITCH
--//==================================================

local CurrentPage

local function ShowPage(name)

    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for buttonName, button in pairs(Buttons) do

        if buttonName == name then
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
            button.TextColor3 = Color3.fromRGB(245, 245, 250)
        else
            button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            button.TextColor3 = Color3.fromRGB(150, 150, 165)
        end

    end

    CurrentPage = name
end

HomeButton.MouseButton1Click:Connect(function()
    ShowPage("Home")
end)

AimButton.MouseButton1Click:Connect(function()
    ShowPage("Aim")
end)

ESPButton.MouseButton1Click:Connect(function()
    ShowPage("ESP")
end)

MiscButton.MouseButton1Click:Connect(function()
    ShowPage("Misc")
end)

SettingsButton.MouseButton1Click:Connect(function()
    ShowPage("Settings")
end)

InfoButton.MouseButton1Click:Connect(function()
    ShowPage("Info")
end)

--//==================================================
--// START PAGE
--//==================================================

ShowPage("Home")

--//==================================================
--// API
--//==================================================

local API = {}

function API.SetStatus(text, online)

    StatusText.Text = text

    if online then
        StatusDot.TextColor3 = Color3.fromRGB(80, 220, 120)
        StatusText.TextColor3 = Color3.fromRGB(145, 235, 165)
        Status.BackgroundColor3 = Color3.fromRGB(22, 42, 30)
    else
        StatusDot.TextColor3 = Color3.fromRGB(255, 90, 90)
        StatusText.TextColor3 = Color3.fromRGB(255, 150, 150)
        Status.BackgroundColor3 = Color3.fromRGB(45, 22, 25)
    end
end

function API.GetPages()
    return Pages
end

function API.GetMain()
    return Main
end

function API.Destroy()
    ScreenGui:Destroy()
end

return API
