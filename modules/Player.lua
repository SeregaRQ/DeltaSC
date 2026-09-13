--//==================================================
--// 🥔 POTATO SCRIPT — PLAYER
--//==================================================

local PS = _G.PotatoScript
if not PS then
    warn("[PotatoScript] Player: PotatoScript не загружен")
    return
end

local PlayerPage = PS.Pages["Player"]
local Colors = PS.Colors
local Players = PS.Players
local LocalPlayer = PS.LocalPlayer
local Camera = PS.Camera
local RunService = PS.RunService

--//==================================================
--// НАСТРОЙКИ
--//==================================================

PS.Player = PS.Player or {}
local P = PS.Player

P.PlayerESP         = P.PlayerESP or false
P.PlayerESPDist     = P.PlayerESPDist or 3000

P.FriendESP         = P.FriendESP or false
P.FriendESPDist     = P.FriendESPDist or 3000

P.NPCESP            = P.NPCESP or false
P.NPCESPDist        = P.NPCESPDist or 3000

P.MineESP           = P.MineESP or false
P.MineESPDist       = P.MineESPDist or 3000

P.CrateESP          = P.CrateESP or false
P.CrateESPDist      = P.CrateESPDist or 3000

--//==================================================
--// ЗАГОЛОВОК
--//==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.fromOffset(5, 5)
title.BackgroundTransparency = 1
title.Text = "Player"
title.TextColor3 = Colors.Text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = PlayerPage

--//==================================================
--// 1. PLAYER ESP
--//==================================================

PS.CreateToggle(PlayerPage, "Player ESP", 45, P.PlayerESP, function(v)
    P.PlayerESP = v
    if not v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("PotatoPlayerESP")
                if hl then hl:Destroy() end
                local bb = p.Character:FindFirstChild("PotatoPlayerESPInfo")
                if bb then bb:Destroy() end
            end
        end
    end
end)

PS.CreateSlider(PlayerPage, "Player ESP Distance", 95, 1, 3000, P.PlayerESPDist, function(v)
    P.PlayerESPDist = v
end)

--//==================================================
--// 2. FRIEND ESP
--//==================================================

PS.CreateToggle(PlayerPage, "Friend ESP", 160, P.FriendESP, function(v)
    P.FriendESP = v
end)

PS.CreateSlider(PlayerPage, "Friend ESP Distance", 210, 1, 3000, P.FriendESPDist, function(v)
    P.FriendESPDist = v
end)

--//==================================================
--// 3. NPC ESP
--//==================================================

PS.CreateToggle(PlayerPage, "NPC ESP", 275, P.NPCESP, function(v)
    P.NPCESP = v
end)

PS.CreateSlider(PlayerPage, "NPC ESP Distance", 325, 1, 3000, P.NPCESPDist, function(v)
    P.NPCESPDist = v
end)

--//==================================================
--// 4. MINE ESP
--//==================================================

PS.CreateToggle(PlayerPage, "Mine ESP", 390, P.MineESP, function(v)
    P.MineESP = v
end)

PS.CreateSlider(PlayerPage, "Mine ESP Distance", 440, 1, 3000, P.MineESPDist, function(v)
    P.MineESPDist = v
end)

--//==================================================
--// 5. CRATE ESP
--//==================================================

PS.CreateToggle(PlayerPage, "Crate ESP", 505, P.CrateESP, function(v)
    P.CrateESP = v
end)

PS.CreateSlider(PlayerPage, "Crate ESP Distance", 555, 1, 3000, P.CrateESPDist, function(v)
    P.CrateESPDist = v
end)

--//==================================================
--// ЦВЕТА
--//==================================================

local COLOR_WHITE   = Color3.fromRGB(255, 255, 255)
local COLOR_RED     = Color3.fromRGB(255, 65, 75)
local COLOR_GREEN   = Color3.fromRGB(70, 210, 125)
local COLOR_YELLOW  = Color3.fromRGB(255, 220, 50)
local COLOR_PURPLE  = Color3.fromRGB(170, 85, 255)
local COLOR_ORANGE  = Color3.fromRGB(255, 150, 50)

--//==================================================
--// ХЕЛПЕРЫ
--//==================================================

local function IsFriend(player)
    local ok, friend = pcall(function()
        return LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return ok and friend
end

local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local dir = part.Position - origin
    local dist = dir.Magnitude

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }

    local result = workspace:Raycast(origin, dir, params)
    if not result then return true end
    if result.Instance:IsDescendantOf(part.Parent) then return true end
    return false
end

local function MakeBillboard(parent, name, text, color, offset)
    local bb = Instance.new("BillboardGui")
    bb.Name = name
    bb.Size = UDim2.fromOffset(200, 40)
    bb.StudsOffset = offset or Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 3000
    bb.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = bb

    return bb, lbl
end

local function MakeHighlight(parent, name, color)
    local hl = Instance.new("Highlight")
    hl.Name = name
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = color
    hl.FillTransparency = 0.85
    hl.OutlineColor = color
    hl.OutlineTransparency = 0
    hl.Parent = parent
    return hl
end

--//==================================================
--// PLAYER ESP — UPDATE
--//==================================================

local playerESPObjects = {}

local function UpdatePlayerESP()
    if not PS.Active then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and head and myRoot then
                local dist = (head.Position - myRoot.Position).Magnitude
                local isFriend = IsFriend(p)

                -- Определяем какой ESP применять
                local showAs = nil
                if isFriend and P.FriendESP and dist <= P.FriendESPDist then
                    showAs = "friend"
                elseif not isFriend and P.PlayerESP and dist <= P.PlayerESPDist then
                    showAs = "player"
                end

                if showAs then
                    -- Цвет
                    local color
                    if showAs == "friend" then
                        color = COLOR_GREEN
                    else
                        -- Player: белый за стеной, красный видно
                        local visible = IsVisible(head)
                        color = visible and COLOR_RED or COLOR_WHITE
                    end

                    -- Highlight
                    local hl = char:FindFirstChild("PotatoPlayerESP")
                    if not hl then
                        hl = MakeHighlight(char, "PotatoPlayerESP", color)
                    end
                    hl.FillColor = color
                    hl.OutlineColor = color

                    -- Billboard
                    local bb = char:FindFirstChild("PotatoPlayerESPInfo")
                    if not bb then
                        bb, _ = MakeBillboard(head, "PotatoPlayerESPInfo", p.Name, color)
                    end
                    local lbl = bb:FindFirstChildOfClass("TextLabel")
                    if lbl then
                        lbl.Text = string.format("%s [%dm]", p.Name, math.floor(dist))
                        lbl.TextColor3 = color
                    end
                else
                    -- Убираем если не должен показываться
                    local hl = char:FindFirstChild("PotatoPlayerESP")
                    if hl then hl:Destroy() end
                    local bb = char:FindFirstChild("PotatoPlayerESPInfo")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end

--//==================================================
--// NPC ESP — UPDATE
--//==================================================

local function IsNPC(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local head = model:FindFirstChild("Head")
    return hum ~= nil and head ~= nil and hum.Health > 0
end

local function UpdateNPCESP()
    if not PS.Active then return end
    if not P.NPCESP then return end

    for _, model in ipairs(workspace:GetDescendants()) do
        if IsNPC(model) then
            local head = model:FindFirstChild("Head")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if head and myRoot then
                local dist = (head.Position - myRoot.Position).Magnitude
                if dist <= P.NPCESPDist then
                    local hl = model:FindFirstChild("PotatoNPCESP")
                    if not hl then
                        hl = MakeHighlight(model, "PotatoNPCESP", COLOR_YELLOW)
                    end
                    local bb = model:FindFirstChild("PotatoNPCESPInfo")
                    if not bb then
                        bb = MakeBillboard(head, "PotatoNPCESPInfo", model.Name, COLOR_YELLOW)
                    end
                    local lbl = bb:FindFirstChildOfClass("TextLabel")
                    if lbl then
                        lbl.Text = string.format("%s [%dm]", model.Name, math.floor(dist))
                    end
                else
                    local hl = model:FindFirstChild("PotatoNPCESP")
                    if hl then hl:Destroy() end
                    local bb = model:FindFirstChild("PotatoNPCESPInfo")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end

--//==================================================
--// MINE ESP — UPDATE
--//==================================================

local MINE_NAMES = {
    ["PMN2"] = true,
    ["MON50"] = true,
    ["GrenadeTrap"] = true,
    ["PMN-2"] = true,
    ["MON-50"] = true,
    ["Landmine"] = true,
    ["Claymore"] = true,
}

local function IsMine(model)
    if not model or not model:IsA("Model") then return false end
    if MINE_NAMES[model.Name] then return true end
    local lower = model.Name:lower()
    if lower:find("mine") or lower:find("pmn") or lower:find("claymore") or lower:find("mon50") then
        return true
    end
    return false
end

local function UpdateMineESP()
    if not PS.Active then return end
    if not P.MineESP then return end

    for _, model in ipairs(workspace:GetDescendants()) do
        if IsMine(model) then
            local prim = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if prim and myRoot then
                local dist = (prim.Position - myRoot.Position).Magnitude
                if dist <= P.MineESPDist then
                    local hl = model:FindFirstChild("PotatoMineESP")
                    if not hl then
                        hl = MakeHighlight(model, "PotatoMineESP", COLOR_PURPLE)
                    end
                    local bb = model:FindFirstChild("PotatoMineESPInfo")
                    if not bb then
                        bb = MakeBillboard(prim, "PotatoMineESPInfo", model.Name, COLOR_PURPLE, Vector3.new(0, 1.5, 0))
                    end
                    local lbl = bb:FindFirstChildOfClass("TextLabel")
                    if lbl then
                        lbl.Text = string.format("%s [%dm]", model.Name, math.floor(dist))
                    end
                else
                    local hl = model:FindFirstChild("PotatoMineESP")
                    if hl then hl:Destroy() end
                    local bb = model:FindFirstChild("PotatoMineESPInfo")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end

--//==================================================
--// CRATE ESP — UPDATE
--//==================================================

local function IsCrate(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    if IsMine(model) then return false end

    local lower = model.Name:lower()
    if lower:find("crate") or lower:find("container") or lower:find("box") or lower:find("chest") then
        return true
    end
    if model:FindFirstChild("Inventory") then
        return true
    end
    return false
end

local function UpdateCrateESP()
    if not PS.Active then return end
    if not P.CrateESP then return end

    for _, model in ipairs(workspace:GetDescendants()) do
        if IsCrate(model) then
            local prim = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if prim and myRoot then
                local dist = (prim.Position - myRoot.Position).Magnitude
                if dist <= P.CrateESPDist then
                    local hl = model:FindFirstChild("PotatoCrateESP")
                    if not hl then
                        hl = MakeHighlight(model, "PotatoCrateESP", COLOR_ORANGE)
                    end
                    local bb = model:FindFirstChild("PotatoCrateESPInfo")
                    if not bb then
                        bb = MakeBillboard(prim, "PotatoCrateESPInfo", model.Name, COLOR_ORANGE, Vector3.new(0, 1.5, 0))
                    end
                    local lbl = bb:FindFirstChildOfClass("TextLabel")
                    if lbl then
                        lbl.Text = string.format("%s [%dm]", model.Name, math.floor(dist))
                    end
                else
                    local hl = model:FindFirstChild("PotatoCrateESP")
                    if hl then hl:Destroy() end
                    local bb = model:FindFirstChild("PotatoCrateESPInfo")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end

--//==================================================
--// ОБНОВЛЕНИЕ (раз в 0.15 сек)
--//==================================================

local espTimer = 0

PS.Connect(RunService.RenderStepped, function(dt)
    if not PS.Active then return end

    espTimer = espTimer + dt
    if espTimer < 0.15 then return end
    espTimer = 0

    UpdatePlayerESP()
    UpdateNPCESP()
    UpdateMineESP()
    UpdateCrateESP()
end)

print("[PotatoScript] Player загружен")
