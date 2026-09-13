--//==================================================
--// 🥔 POTATO SCRIPT — LOAD SCRIPT
--//==================================================

print("[PotatoScript] Загрузка...")

-- Очистка старой сессии
if _G.PotatoScript then
    if _G.PotatoScript.GUI then
        pcall(function() _G.PotatoScript.GUI:Destroy() end)
    end
    _G.PotatoScript = nil
end

-- Глобальное хранилище
_G.PotatoScript = {
    Active = true,
    Modules = {},
    Loaded = {},
    Version = "1.0.0",
    Author = "SeregaRQno"
}

local PS = _G.PotatoScript

--//==================================================
--// ЗАГРУЗКА МОДУЛЕЙ
--//==================================================

local BASE_URL = "https://raw.githubusercontent.com/SeregaRQ/PotatoProject/main/modules/"

local Modules = {
    "Core",
    "Aim",
    "Player",
    "World",
    "Misc",
    "Settings",
    "Info",
}

local function LoadModule(name)
    if not PS.Active then
        warn("[PotatoScript] Отмена загрузки: " .. name)
        return false
    end

    local url = BASE_URL .. name .. ".lua"
    local success, code = pcall(function()
        return game:HttpGet(url)
    end)

    if not success or not code then
        warn("[PotatoScript] Не удалось загрузить " .. name)
        return false
    end

    local fn, err = loadstring(code)
    if not fn then
        warn("[PotatoScript] Ошибка компиляции " .. name .. ": " .. tostring(err))
        return false
    end

    local ok, result = pcall(fn)
    if not ok then
        warn("[PotatoScript] Ошибка выполнения " .. name .. ": " .. tostring(result))
        return false
    end

    PS.Loaded[name] = true
    print("[PotatoScript] ✅ " .. name .. " загружен")
    return true
end

-- Загружаем все модули по порядку
for _, moduleName in ipairs(Modules) do
    LoadModule(moduleName)
    task.wait(0.05)
end

print("[PotatoScript] 🥔 Готово!")
