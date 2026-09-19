# DeltaSC

Modular Lua application scaffold.

## Structure

```text
DeltaSC/
├── Main.lua
└── Modules/
    ├── Aim.lua
    ├── ESP.lua
    ├── Player.lua
    ├── World.lua
    ├── Misc.lua
    ├── Settings.lua
    └── Info.lua
```

Run with a Lua interpreter from the repository root:

```bash
lua Main.lua
```

The modules are intentionally safe extension points and contain no exploit, credential theft, evasion, or unauthorized-access functionality.
