local Info = {
    name = "DeltaSC",
    version = "0.1.0",
    description = "A modular Lua application scaffold."
}

function Info.init()
    if Info.version == nil then
        error("DeltaSC version is not configured")
    end
end

return Info
