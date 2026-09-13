--//==================================================
--// 🥔 POTATO SCRIPT — WORLD
--//==================================================

local PS = _G.PotatoScript
if not PS then
    warn("[PotatoScript] World: PotatoScript не загружен")
    return
end

local WorldPage = PS.Pages["World"]
local Colors = PS.Colors
local Lighting = PS.Lighting
local RunService = PS.RunService

--//==================================================
--// НАСТРОЙКИ
--//==================================================

PS.World = PS.World or {}
local W = PS.World

W.Fullbright  = W.Fullbright or false
W.TimeLock    = W.TimeLock or false
W.Time        = W.Time or 14
W.RemoveGrass = W.RemoveGrass or false
W.RemoveFog   = W.RemoveFog or false

W.AmbientR    = W.AmbientR or 128
W.AmbientG    = W.AmbientG or 128
W.AmbientB    = W.AmbientB or 128

W.SkyR        = W.SkyR or 128
W.SkyG        = W.SkyG or 128
W.SkyB        = W.SkyB or 128

W.CShiftR     = W.CShiftR or 128
W.CShiftG     = W.CShiftG or 128
W.CShiftB     = W.CShiftB or 128

--//==================================================
--// ОРИГИНАЛЫ
--//==================================================

local Orig = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShiftTop = Lighting.ColorShift_Top,
    ColorShiftBottom = Lighting.ColorShift_Bottom,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    ClockTime = Lighting.ClockTime,
}

PS.RestoreLighting = function()
    pcall(function()
        Lighting.Brightness = Orig.Brightness
        Lighting.Ambient = Orig.Ambient
        Lighting.OutdoorAmbient = Orig.OutdoorAmbient
        Lighting.ColorShift_Top = Orig.ColorShiftTop
        Lighting.ColorShift_Bottom = Orig.ColorShiftBottom
        Lighting.GlobalShadows = Orig.GlobalShadows
        Lighting.FogEnd = Orig.FogEnd
        Lighting.FogStart = Orig.FogStart
        Lighting.ClockTime = Orig.ClockTime
    end)
end

--//==================================================
--// ЗАГОЛОВОК
--//==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.fromOffset(5, 5)
title.BackgroundTransparency = 1
title.Text = "World"
title.TextColor3 = Colors.Text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = WorldPage

--//==================================================
--// FULLBRIGHT
--//==================================================

PS.CreateToggle(WorldPage, "Fullbright", 45, W.Fullbright, function(v)
    W.Fullbright = v
end)

--//==================================================
--// TIME LOCK
--//==================================================

PS.CreateToggle(WorldPage, "Time Lock", 95, W.TimeLock, function(v)
    W.TimeLock = v
end)

--//==================================================
--// WORLD TIME
--//==================================================

PS.CreateSlider(WorldPage, "World Time", 145, 1, 24, W.Time, function(v)
    W.Time = v
end)

--//==================================================
--// REMOVE GRASS (через замену материала)
--//==================================================

local function RemoveGrassTerrain()
    local Terrain = workspace.Terrain
    local region = Region3.new(Vector3.new(-2048, -100, -2048), Vector3.new(2048, 500, 2048))
    
    pcall(function()
        Terrain:ReplaceMaterial(region, 4, Enum.Material.Grass, Enum.Material.Asphalt)
    end)
end

PS.CreateToggle(WorldPage, "Remove Grass", 210, W.RemoveGrass, function(v)
    W.RemoveGrass = v

    if v then
        RemoveGrassTerrain()
    end
end)

--//==================================================
--// REMOVE FOG
--//==================================================

PS.CreateToggle(WorldPage, "Remove Fog", 260, W.RemoveFog, function(v)
    W.RemoveFog = v
end)

--//==================================================
--// RGB SECTION
--//==================================================

local function CreateRGB(parent, name, y, getR, setR, getG, setG, getB, setB)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -10, 0, 20)
    header.Position = UDim2.fromOffset(8, y)
    header.BackgroundTransparency = 1
    header.Text = name
    header.TextColor3 = Colors.Accent
    header.TextSize = 13
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = parent

    PS.CreateSlider(parent, "  R", y + 25, 0, 255, getR(), function(v) setR(v) end)
    PS.CreateSlider(parent, "  G", y + 90, 0, 255, getG(), function(v) setG(v) end)
    PS.CreateSlider(parent, "  B", y + 155, 0, 255, getB(), function(v) setB(v) end)
end

CreateRGB(WorldPage, "Ambient Color", 320,
    function() return W.AmbientR end, function(v) W.AmbientR = v end,
    function() return W.AmbientG end, function(v) W.AmbientG = v end,
    function() return W.AmbientB end, function(v) W.AmbientB = v end
)

CreateRGB(WorldPage, "Sky Color", 560,
    function() return W.SkyR end, function(v) W.SkyR = v end,
    function() return W.SkyG end, function(v) W.SkyG = v end,
    function() return W.SkyB end, function(v) W.SkyB = v end
)

CreateRGB(WorldPage, "ColorShift Top", 800,
    function() return W.CShiftR end, function(v) W.CShiftR = v end,
    function() return W.CShiftG end, function(v) W.CShiftG = v end,
    function() return W.CShiftB end, function(v) W.CShiftB = v end
)

--//==================================================
--// ЛОГИКА
--//==================================================

PS.Connect(RunService.RenderStepped, function()
    if not PS.Active then return end

    -- Fullbright
    if W.Fullbright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
    end

    -- Time Lock
    if W.TimeLock then
        Lighting.ClockTime = W.Time
    end

    -- Remove Fog
    if W.RemoveFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    end

    -- Ambient
    local ambient = Color3.fromRGB(W.AmbientR, W.AmbientG, W.AmbientB)
    Lighting.Ambient = ambient
    Lighting.OutdoorAmbient = ambient

    -- Sky
    Lighting.ColorShift_Bottom = Color3.fromRGB(W.SkyR, W.SkyG, W.SkyB)

    -- ColorShift Top
    Lighting.ColorShift_Top = Color3.fromRGB(W.CShiftR, W.CShiftG, W.CShiftB)
end)

print("[PotatoScript] World загружен")
