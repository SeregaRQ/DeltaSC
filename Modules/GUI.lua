local GUI = {
    loaded = false
}

function GUI.init()
    -- Initialize the interface before any other module is loaded.
    GUI.loaded = true
    print("GUI loaded")
end

return GUI
