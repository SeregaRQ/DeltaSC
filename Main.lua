-- DeltaSC entry point
-- Safe modular application scaffold.

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
