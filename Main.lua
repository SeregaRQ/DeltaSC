local Modules = script.Parent:WaitForChild("Modules")

local function load(name)
    local module = Modules:WaitForChild(name)

    if not module:IsA("ModuleScript") then
        warn("[DeltaSC] " .. name .. " is not a ModuleScript")
        return
    end

    local ok, result = pcall(require, module)

    if not ok then
        warn("[DeltaSC] " .. name .. " failed: " .. tostring(result))
        return
    end

    return result
end

-- GUI first
load("GUI")

-- Remaining modules
for _, name in ipairs({
    "Aim",
    "ESP",
    "Info",
    "Misc",
    "Player",
    "Settings",
    "World"
}) do
    load(name)
end

print("[DeltaSC] Loaded successfully")
