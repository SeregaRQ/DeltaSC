-- DeltaSC entry point
-- Safe modular application scaffold.

local GUI = require("Modules.GUI")

GUI.init()

-- Give the interface time to initialize before loading the remaining modules.
-- Override this function in an embedding application if it has its own scheduler.
local function wait_seconds(seconds)
    local start = os.clock()
    while os.clock() - start < seconds do
        -- Deliberately yield through a short sleep where available.
        if package.config:sub(1, 1) == "\\" then
            os.execute("timeout /t 1 /nobreak >nul")
        else
            os.execute("sleep 1")
        end
    end
end

wait_seconds(2)

local Modules = {
    require("Modules.Settings"),
    require("Modules.Info"),
    require("Modules.Player"),
    require("Modules.World"),
    require("Modules.Misc"),
    require("Modules.Aim"),
    require("Modules.ESP")
}

for _, module in ipairs(Modules) do
    if type(module.init) == "function" then
        module.init()
    end
end

print("DeltaSC started")
