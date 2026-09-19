# DeltaSC

Modular Lua application scaffold.

## Structure

```text
DeltaSC/
├── Main.lua
└── Modules/
    ├── GUI.lua       # Loaded first
    ├── Aim.lua
    ├── ESP.lua
    ├── Player.lua
    ├── World.lua
    ├── Misc.lua
    ├── Settings.lua
    └── Info.lua
```

`Main.lua` initializes `GUI.lua` first, waits two seconds, and then initializes the remaining modules.

Run with a Lua interpreter from the repository root:

```bash
lua Main.lua
```

The modules are intentionally safe extension points and contain no exploit, credential theft, evasion, or unauthorized-access functionality.
