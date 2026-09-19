--// DeltaSC Main
--// Roblox Studio / обычный LocalScript

local Modules = script.Parent:WaitForChild("Modules")

local function loadModule(name)
    local module = Modules:WaitForChild(name)

    assert(
        module:IsA("ModuleScript"),
        name .. " must be a ModuleScript"
    )

    local success, result = pcall(require, module)

    if not success then
        warn("[DeltaSC] Failed to load " .. name .. ": " .. tostring(result))
        return nil
    end

    return result
end

-- GUI MUST LOAD FIRST
local GUI = loadModule("GUI")

-- Other modules
local Aim = loadModule("Aim")
local ESP = loadModule("ESP")
local Info = loadModule("Info")
local Misc = loadModule("Misc")
local Player = loadModule("Player")
local Settings = loadModule("Settings")
local World = loadModule("World")

print("[DeltaSC] All modules loaded.")
