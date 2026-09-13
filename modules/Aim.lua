--//==================================================
--// 🥔 POTATO SCRIPT — AIM
--//==================================================

local PS = _G.PotatoScript
if not PS then
    warn("[PotatoScript] Aim: PotatoScript не загружен")
    return
end

local AimPage = PS.Pages["Aim"]
local Colors = PS.Colors
local Players = PS.Players
local LocalPlayer = PS.LocalPlayer
local Camera = PS.Camera
local RunService = PS.RunService
local UserInputService = PS.UserInputService
local TweenService = PS.TweenService

--//==================================================
--// НАСТРОЙКИ
--//==================================================

PS.Aim = PS.Aim or {}
local A = PS.Aim

A.Enabled = A.Enabled or false
A.Key = A.Key or Enum.UserInputType.MouseButton2
A.Smooth = A.Smooth or 0.15
A.FOV = A.FOV or 180
A.CircleFOV = A.CircleFOV or false
A.Wallcheck = A.Wallcheck or true
A.IgnoreFriends = A.IgnoreFriends or true
A.Prediction = A.Prediction or false
A.PredictionStrength = A.PredictionStrength or 0.12
A.TargetBone = A.TargetBone or "Head"
A.TargetHighlight = A.TargetHighlight or false
A.NoRecoil = A.NoRecoil or false
A.Zoom = A.Zoom or false
A.ZoomStrength = A.ZoomStrength or 60
A.ZoomKey = A.ZoomKey or "V"
A.Crosshair = A.Crosshair or false
A.CrosshairSize = A.CrosshairSize or 40

--//==================================================
--// ЗАГОЛОВОК
--//==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.fromOffset(5, 5)
title.BackgroundTransparency = 1
title.Text = "Aimbot"
title.TextColor3 = Colors.Text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = AimPage

--//==================================================
--// 1. AIMBOT TOGGLE
--//==================================================

PS.CreateToggle(AimPage, "Aimbot (RMB Hold)", 45, A.Enabled, function(v)
    A.Enabled = v
end)

--//==================================================
--// 2. AIMBOT KEYBIND
--//==================================================

local kbHolder = Instance.new("Frame")
kbHolder.Size = UDim2.new(1, -10, 0, 42)
kbHolder.Position = UDim2.fromOffset(5, 95)
kbHolder.BackgroundColor3 = Colors.Panel
kbHolder.BorderSizePixel = 0
kbHolder.Parent = AimPage

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 9)
kbCorner.Parent = kbHolder

local kbLabel = Instance.new("TextLabel")
kbLabel.Size = UDim2.new(1, -100, 1, 0)
kbLabel.Position = UDim2.fromOffset(14, 0)
kbLabel.BackgroundTransparency = 1
kbLabel.Text = "Aimbot Key"
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
kbBtn.Text = tostring(A.Key.Name or "RMB")
kbBtn.TextColor3 = Colors.Accent
kbBtn.TextSize = 12
kbBtn.Font = Enum.Font.GothamBold
kbBtn.AutoButtonColor = false
kbBtn.Parent = kbHolder

local kbBtnCorner = Instance.new("UICorner")
kbBtnCorner.CornerRadius = UDim.new(0, 6)
kbBtnCorner.Parent = kbBtn

local listeningAimKey = false

PS.Connect(kbBtn.MouseButton1Click, function()
    listeningAimKey = true
    kbBtn.Text = "..."
    kbBtn.TextColor3 = Colors.Orange
end)

PS.Connect(UserInputService.InputBegan, function(input, processed)
    if not listeningAimKey then return end
    if processed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        A.Key = Enum.UserInputType.MouseButton1
        kbBtn.Text = "LMB"
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        A.Key = Enum.UserInputType.MouseButton2
        kbBtn.Text = "RMB"
    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
        A.Key = Enum.UserInputType.MouseButton3
        kbBtn.Text = "MMB"
    elseif input.KeyCode ~= Enum.KeyCode.Unknown then
        A.Key = input.KeyCode
        kbBtn.Text = input.KeyCode.Name
    else
        return
    end

    kbBtn.TextColor3 = Colors.Accent
    listeningAimKey = false
end)

--//==================================================
--// 3. SMOOTH SLIDER
--//==================================================

PS.CreateSlider(AimPage, "Smooth", 145, 0.01, 1, A.Smooth, function(v)
    A.Smooth = v
end)

--//==================================================
--// 4. FOV RADIUS SLIDER
--//==================================================

PS.CreateSlider(AimPage, "FOV Radius", 210, 30, 500, A.FOV, function(v)
    A.FOV = v
end)

--//==================================================
--// 5. CIRCLE FOV TOGGLE
--//==================================================

PS.CreateToggle(AimPage, "Circle FOV", 275, A.CircleFOV, function(v)
    A.CircleFOV = v
end)

--//==================================================
--// 6. WALLCHECK
--//==================================================

PS.CreateToggle(AimPage, "Wallcheck", 325, A.Wallcheck, function(v)
    A.Wallcheck = v
end)

--//==================================================
--// 7. FRIEND IGNORE
--//==================================================

PS.CreateToggle(AimPage, "Friend Ignore", 375, A.IgnoreFriends, function(v)
    A.IgnoreFriends = v
end)

--//==================================================
--// 8. PREDICTION
--//==================================================

PS.CreateToggle(AimPage, "Prediction", 425, A.Prediction, function(v)
    A.Prediction = v
end)

--//==================================================
--// 9. PREDICTION STRENGTH
--//==================================================

PS.CreateSlider(AimPage, "Prediction Strength", 475, 0.01, 0.5, A.PredictionStrength, function(v)
    A.PredictionStrength = v
end)

--//==================================================
--// 10. TARGET BONE (Head / Body)
--//==================================================

local boneHolder = Instance.new("Frame")
boneHolder.Size = UDim2.new(1, -10, 0, 42)
boneHolder.Position = UDim2.fromOffset(5, 540)
boneHolder.BackgroundColor3 = Colors.Panel
boneHolder.BorderSizePixel = 0
boneHolder.Parent = AimPage

local boneCorner = Instance.new("UICorner")
boneCorner.CornerRadius = UDim.new(0, 9)
boneCorner.Parent = boneHolder

local boneLabel = Instance.new("TextLabel")
boneLabel.Size = UDim2.new(0.4, 0, 1, 0)
boneLabel.Position = UDim2.fromOffset(14, 0)
boneLabel.BackgroundTransparency = 1
boneLabel.Text = "Target Bone"
boneLabel.TextColor3 = Colors.Text
boneLabel.TextSize = 13
boneLabel.Font = Enum.Font.GothamMedium
boneLabel.TextXAlignment = Enum.TextXAlignment.Left
boneLabel.Parent = boneHolder

local function CreateBoneBtn(text, xPos, boneName)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(60, 26)
    b.Position = UDim2.new(1, xPos, 0.5, -13)
    b.BackgroundColor3 = (A.TargetBone == boneName) and Colors.Accent or Colors.Panel2
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Colors.Text
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = boneHolder

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = b

    PS.Connect(b.MouseButton1Click, function()
        A.TargetBone = boneName
        for _, child in ipairs(boneHolder:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Colors.Panel2
            end
        end
        b.BackgroundColor3 = Colors.Accent
    end)
end

CreateBoneBtn("Head", -200, "Head")
CreateBoneBtn("Body", -135, "HumanoidRootPart")

--//==================================================
--// 11. TARGET HIGHLIGHT
--//==================================================

PS.CreateToggle(AimPage, "Target Highlight", 590, A.TargetHighlight, function(v)
    A.TargetHighlight = v
end)

--//==================================================
--// 12. NO RECOIL
--//==================================================

PS.CreateToggle(AimPage, "No Recoil", 640, A.NoRecoil, function(v)
    A.NoRecoil = v
end)

--//==================================================
--// 13. ZOOM TOGGLE
--//==================================================

PS.CreateToggle(AimPage, "Zoom", 690, A.Zoom, function(v)
    A.Zoom = v
end)

--//==================================================
--// 14. ZOOM STRENGTH
--//==================================================

PS.CreateSlider(AimPage, "Zoom Strength", 740, 0, 100, A.ZoomStrength, function(v)
    A.ZoomStrength = v
end)

--//==================================================
--// 15. ZOOM KEYBIND
--//==================================================

local zHolder = Instance.new("Frame")
zHolder.Size = UDim2.new(1, -10, 0, 42)
zHolder.Position = UDim2.fromOffset(5, 805)
zHolder.BackgroundColor3 = Colors.Panel
zHolder.BorderSizePixel = 0
zHolder.Parent = AimPage

local zCorner = Instance.new("UICorner")
zCorner.CornerRadius = UDim.new(0, 9)
zCorner.Parent = zHolder

local zLabel = Instance.new("TextLabel")
zLabel.Size = UDim2.new(1, -100, 1, 0)
zLabel.Position = UDim2.fromOffset(14, 0)
zLabel.BackgroundTransparency = 1
zLabel.Text = "Zoom Keybind"
zLabel.TextColor3 = Colors.Text
zLabel.TextSize = 13
zLabel.Font = Enum.Font.GothamMedium
zLabel.TextXAlignment = Enum.TextXAlignment.Left
zLabel.Parent = zHolder

local zBtn = Instance.new("TextButton")
zBtn.Size = UDim2.fromOffset(80, 26)
zBtn.Position = UDim2.new(1, -90, 0.5, -13)
zBtn.BackgroundColor3 = Colors.Panel2
zBtn.BorderSizePixel = 0
zBtn.Text = A.ZoomKey
zBtn.TextColor3 = Colors.Accent
zBtn.TextSize = 12
zBtn.Font = Enum.Font.GothamBold
zBtn.AutoButtonColor = false
zBtn.Parent = zHolder

local zBtnCorner = Instance.new("UICorner")
zBtnCorner.CornerRadius = UDim.new(0, 6)
zBtnCorner.Parent = zBtn

local listeningZoomKey = false

PS.Connect(zBtn.MouseButton1Click, function()
    listeningZoomKey = true
    zBtn.Text = "..."
    zBtn.TextColor3 = Colors.Orange
end)

PS.Connect(UserInputService.InputBegan, function(input, processed)
    if not listeningZoomKey then return end
    if processed then return end
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        A.ZoomKey = input.KeyCode.Name
        zBtn.Text = A.ZoomKey
        zBtn.TextColor3 = Colors.Accent
        listeningZoomKey = false
    end
end)

--//==================================================
--// 16. CROSSHAIR TOGGLE
--//==================================================

PS.CreateToggle(AimPage, "Crosshair", 855, A.Crosshair, function(v)
    A.Crosshair = v
    if PS.CrosshairFrame then
        PS.CrosshairFrame.Visible = v
    end
end)

--//==================================================
--// 17. CROSSHAIR SIZE
--//==================================================

PS.CreateSlider(AimPage, "Crosshair Size", 905, 20, 80, A.CrosshairSize, function(v)
    A.CrosshairSize = v
    if PS.CrosshairFrame then
        PS.CrosshairFrame.Size = UDim2.fromOffset(v, v)
        PS.CrosshairFrame.Position = UDim2.new(0.5, -v/2, 0.5, -v/2)
    end
end)

--//==================================================
--// ЛОГИКА: TARGET FINDER
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

local function GetClosestTarget()
    local closest, closestDist = nil, A.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local part = char and char:FindFirstChild(A.TargetBone)

            if char and hum and hum.Health > 0 and part then
                if not (A.IgnoreFriends and IsFriend(p)) then
                    local visible = true
                    if A.Wallcheck then
                        visible = IsVisible(part)
                    end

                    if visible then
                        local sPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen and sPos.Z > 0 then
                            local dist = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

--//==================================================
--// ЛОГИКА: AIMBOT HOLD
--//==================================================

local AimHolding = false

PS.Connect(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    if A.Key == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimHolding = true
    elseif A.Key == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1 then
        AimHolding = true
    elseif A.Key == Enum.UserInputType.MouseButton3 and input.UserInputType == Enum.UserInputType.MouseButton3 then
        AimHolding = true
    elseif input.KeyCode == A.Key then
        AimHolding = true
    end
end)

PS.Connect(UserInputService.InputEnded, function(input)
    if A.Key == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimHolding = false
    elseif A.Key == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1 then
        AimHolding = false
    elseif A.Key == Enum.UserInputType.MouseButton3 and input.UserInputType == Enum.UserInputType.MouseButton3 then
        AimHolding = false
    elseif input.KeyCode == A.Key then
        AimHolding = false
    end
end)

--//==================================================
--// ЛОГИКА: AIMBOT UPDATE
--//==================================================

PS.Connect(RunService.RenderStepped, function()
    if not PS.Active then return end
    if not A.Enabled or not AimHolding then return end

    local target = GetClosestTarget()
    if not target then return end

    local aimPos = target.Position

    -- Prediction
    if A.Prediction then
        local char = target.Parent
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            aimPos = aimPos + (root.AssemblyLinearVelocity * A.PredictionStrength)
        end
    end

    local camPos = Camera.CFrame.Position
    local targetCF = CFrame.lookAt(camPos, aimPos)
    Camera.CFrame = Camera.CFrame:Lerp(targetCF, A.Smooth)
end)

--//==================================================
--// ЛОГИКА: FOV CIRCLE
--//==================================================

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Size = UDim2.fromOffset(A.FOV * 2, A.FOV * 2)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.ZIndex = 10
fovCircle.Parent = PS.GUI

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Colors.Accent
fovStroke.Thickness = 2
fovStroke.Transparency = 0.15
fovStroke.Parent = fovCircle

local fovGlow = Instance.new("UIStroke")
fovGlow.Color = Colors.Accent
fovGlow.Thickness = 6
fovGlow.Transparency = 0.85
fovGlow.Parent = fovCircle

local currentFOVColor = Colors.Accent
local currentGlowColor = Colors.Accent
local currentThickness = 2
local pulsePhase = 0

PS.Connect(RunService.RenderStepped, function(dt)
    if not PS.Active then return end

    fovCircle.Visible = A.CircleFOV
    fovCircle.Size = UDim2.fromOffset(A.FOV * 2, A.FOV * 2)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)

    if not fovCircle.Visible then return end

    local hasTarget = false
    if A.Enabled then
        local found = GetClosestTarget()
        if found then hasTarget = true end
    end

    local targetColor = hasTarget and Color3.fromRGB(255, 65, 75) or Colors.Accent
    local targetGlow = hasTarget and Color3.fromRGB(255, 80, 90) or Colors.Accent
    local targetThick = hasTarget and 2.5 or 2

    local lerpSpeed = math.clamp(dt * 12, 0, 1)
    currentFOVColor = currentFOVColor:Lerp(targetColor, lerpSpeed)
    currentGlowColor = currentGlowColor:Lerp(targetGlow, lerpSpeed)
    currentThickness = currentThickness + (targetThick - currentThickness) * lerpSpeed

    if hasTarget then
        pulsePhase = pulsePhase + dt * 8
        local pulse = math.sin(pulsePhase) * 0.5 + 0.5
        fovStroke.Thickness = currentThickness + (pulse * 0.8)
        fovStroke.Transparency = 0
        fovGlow.Thickness = 6 + (pulse * 4)
        fovGlow.Transparency = 0.7 + (pulse * 0.2)
    else
        pulsePhase = 0
        fovStroke.Thickness = currentThickness
        fovStroke.Transparency = 0.15
        fovGlow.Thickness = 6
        fovGlow.Transparency = 0.85
    end

    fovStroke.Color = currentFOVColor
    fovGlow.Color = currentGlowColor
end)

--//==================================================
--// ЛОГИКА: TARGET HIGHLIGHT
--//==================================================

local highlightObj = nil

PS.Connect(RunService.RenderStepped, function()
    if not PS.Active then return end

    if not A.TargetHighlight then
        if highlightObj then
            highlightObj:Destroy()
            highlightObj = nil
        end
        return
    end

    local target = GetClosestTarget()
    if target then
        local char = target.Parent
        if not highlightObj or highlightObj.Parent ~= char then
            if highlightObj then highlightObj:Destroy() end
            highlightObj = Instance.new("Highlight")
            highlightObj.FillColor = Color3.fromRGB(255, 65, 75)
            highlightObj.FillTransparency = 0.5
            highlightObj.OutlineColor = Color3.fromRGB(255, 65, 75)
            highlightObj.OutlineTransparency = 0
            highlightObj.Parent = char
        end
    else
        if highlightObj then
            highlightObj:Destroy()
            highlightObj = nil
        end
    end
end)

--//==================================================
--// ЛОГИКА: NO RECOIL
--//==================================================

local origRecoil = {}

PS.Connect(RunService.RenderStepped, function()
    if not PS.Active then return end

    local ammoTypes = game:GetService("ReplicatedStorage"):FindFirstChild("AmmoTypes")
    if not ammoTypes then return end

    for _, ammo in ipairs(ammoTypes:GetChildren()) do
        if origRecoil[ammo] == nil then
            origRecoil[ammo] = ammo:GetAttribute("RecoilStrength")
        end

        if A.NoRecoil then
            ammo:SetAttribute("RecoilStrength", 0)
        else
            if origRecoil[ammo] ~= nil then
                ammo:SetAttribute("RecoilStrength", origRecoil[ammo])
            end
        end
    end
end)

--//==================================================
--// ЛОГИКА: ZOOM
--//==================================================

local zoomHolding = false
local zoomRestore = nil
local listeningZoomKey2 = false

PS.Connect(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    if not A.Zoom then return end

    if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name == A.ZoomKey then
        local cam = workspace.CurrentCamera
        if cam and not zoomHolding then
            zoomHolding = true
            zoomRestore = cam.FieldOfView
        end
    end
end)

PS.Connect(UserInputService.InputEnded, function(input)
    if not A.Zoom then return end

    if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name == A.ZoomKey then
        zoomHolding = false
        local cam = workspace.CurrentCamera
        if cam and zoomRestore then
            cam.FieldOfView = zoomRestore
        end
        zoomRestore = nil
    end
end)

PS.Connect(RunService.RenderStepped, function()
    if not PS.Active then return end
    if not A.Zoom or not zoomHolding then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    if zoomRestore == nil then
        zoomRestore = cam.FieldOfView
    end

    local targetFOV = 90 - (A.ZoomStrength / 100) * 75
    cam.FieldOfView = targetFOV
end)

--//==================================================
--// ЛОГИКА: CROSSHAIR
--//==================================================

local crossGui = Instance.new("ScreenGui")
crossGui.Name = "PotatoCrosshair"
crossGui.ResetOnSpawn = false
crossGui.IgnoreGuiInset = true
crossGui.Parent = PS.Parent

local crossFrame = Instance.new("Frame")
crossFrame.Size = UDim2.fromOffset(A.CrosshairSize, A.CrosshairSize)
crossFrame.Position = UDim2.new(0.5, -A.CrosshairSize/2, 0.5, -A.CrosshairSize/2)
crossFrame.BackgroundTransparency = 1
crossFrame.Visible = false
crossFrame.Parent = crossGui

PS.CrosshairFrame = crossFrame

local dot = Instance.new("Frame")
dot.Size = UDim2.fromOffset(2, 2)
dot.Position = UDim2.new(0.5, -1, 0.5, -1)
dot.BackgroundColor3 = Colors.Accent
dot.BorderSizePixel = 0
dot.Parent = crossFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local function MakeLine(x, y, sx, sy)
    local l = Instance.new("Frame")
    l.Size = UDim2.fromOffset(sx, sy)
    l.Position = UDim2.new(x, 0, y, 0)
    l.BackgroundColor3 = Colors.Accent
    l.BorderSizePixel = 0
    l.Parent = crossFrame
    return l
end

local lineUp = MakeLine(0.5, 0, 2, 10)
lineUp.Position = UDim2.new(0.5, -1, 0, 0)

local lineDown = MakeLine(0.5, 1, 2, 10)
lineDown.Position = UDim2.new(0.5, -1, 1, -10)

local lineLeft = MakeLine(0, 0.5, 10, 2)
lineLeft.Position = UDim2.new(0, 0, 0.5, -1)

local lineRight = MakeLine(1, 0.5, 10, 2)
lineRight.Position = UDim2.new(1, -10, 0.5, -1)

print("[PotatoScript] Aim загружен")
