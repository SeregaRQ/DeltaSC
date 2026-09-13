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

PS.CreateSection(WorldPage, "Lighting")

--//==================================================
--// FULLBRIGHT
--//==================================================

PS.CreateToggle(WorldPage, "Fullbright", 0, W.Fullbright, function(v)
    W.Fullbright = v
    if not v then
        Lighting.Brightness = Orig.Brightness
        Lighting.GlobalShadows = Orig.GlobalShadows
    end
end)

--//==================================================
--// TIME LOCK
--//==================================================

PS.CreateToggle(WorldPage, "Time Lock", 0, W.TimeLock, function(v)
    W.TimeLock = v
    if not v then
        Lighting.ClockTime = Orig.ClockTime
    end
end)

--//==================================================
--// WORLD TIME
--//==================================================

PS.CreateSlider(WorldPage, "World Time", 0, 1, 24, W.Time, function(v)
    W.Time = v
end)

--//==================================================
--// REMOVE FOG
--//==================================================

PS.CreateToggle(WorldPage, "Remove Fog", 0, W.RemoveFog, function(v)
    W.RemoveFog = v
    if not v then
        Lighting.FogEnd = Orig.FogEnd
        Lighting.FogStart = Orig.FogStart
    end
end)

--//==================================================
--// REMOVE GRASS
--//==================================================

local function ReplaceGrassWithAsphalt()
    local Terrain = workspace.Terrain
    local region = Region3.new(
        Vector3.new(-2048, -100, -2048),
        Vector3.new(2048, 500, 2048)
    )
    pcall(function()
        Terrain:ReplaceMaterial(region, 4, Enum.Material.Grass, Enum.Material.Asphalt)
    end)
end

PS.CreateToggle(WorldPage, "Remove Grass", 0, W.RemoveGrass, function(v)
    W.RemoveGrass = v
    if v then
        ReplaceGrassWithAsphalt()
    end
end)

--//==================================================
--// RGB СЕКЦИИ
--//==================================================

-- Ambient Color
PS.CreateSection(WorldPage, "Ambient Color")

PS.CreateSlider(WorldPage, "  R", 0, 0, 255, W.AmbientR, function(v) W.AmbientR = v end)
PS.CreateSlider(WorldPage, "  G", 0, 0, 255, W.AmbientG, function(v) W.AmbientG = v end)
PS.CreateSlider(WorldPage, "  B", 0, 0, 255, W.AmbientB, function(v) W.AmbientB = v end)

-- Sky Color
PS.CreateSection(WorldPage, "Sky Color")

PS.CreateSlider(WorldPage, "  R", 0, 0, 255, W.SkyR, function(v) W.SkyR = v end)
PS.CreateSlider(WorldPage, "  G", 0, 0, 255, W.SkyG, function(v) W.SkyG = v end)
PS.CreateSlider(WorldPage, "  B", 0, 0, 255, W.SkyB, function(v) W.SkyB = v end)

-- ColorShift Top
PS.CreateSection(WorldPage, "ColorShift Top")

PS.CreateSlider(WorldPage, "  R", 0, 0, 255, W.CShiftR, function(v) W.CShiftR = v end)
PS.CreateSlider(WorldPage, "  G", 0, 0, 255, W.CShiftG, function(v) W.CShiftG = v end)
PS.CreateSlider(WorldPage, "  B", 0, 0, 255, W.CShiftB, function(v) W.CShiftB = v end)

--//==================================================
--// ЛОГИКА
--//==================================================

PS.Connect(RunService.RenderStepped, function()
    if not PS.Active then return end

    -- FULLBRIGHT
    if W.Fullbright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = Orig.Brightness
        Lighting.GlobalShadows = Orig.GlobalShadows
    end

    -- TIME LOCK
    if W.TimeLock then
        Lighting.ClockTime = W.Time
    else
        Lighting.ClockTime = Orig.ClockTime
    end

    -- REMOVE FOG
    if W.RemoveFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        Lighting.FogEnd = Orig.FogEnd
        Lighting.FogStart = Orig.FogStart
    end

    -- AMBIENT
    if W.AmbientR ~= 128 or W.AmbientG ~= 128 or W.AmbientB ~= 128 then
        local ambient = Color3.fromRGB(W.AmbientR, W.AmbientG, W.AmbientB)
        Lighting.Ambient = ambient
        Lighting.OutdoorAmbient = ambient
    else
        Lighting.Ambient = Orig.Ambient
        Lighting.OutdoorAmbient = Orig.OutdoorAmbient
    end

    -- SKY
    if W.SkyR ~= 128 or W.SkyG ~= 128 or W.SkyB ~= 128 then
        Lighting.ColorShift_Bottom = Color3.fromRGB(W.SkyR, W.SkyG, W.SkyB)
    else
        Lighting.ColorShift_Bottom = Orig.ColorShiftBottom
    end

    -- ColorShift Top
    if W.CShiftR ~= 128 or W.CShiftG ~= 128 or W.CShiftB ~= 128 then
        Lighting.ColorShift_Top = Color3.fromRGB(W.CShiftR, W.CShiftG, W.CShiftB)
    else
        Lighting.ColorShift_Top = Orig.ColorShiftTop
    end
end)

print("[PotatoScript] World загружен")
