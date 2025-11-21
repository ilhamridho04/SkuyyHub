# WindUI Copilot Instructions

## Architecture Overview

WindUI is a **Roblox UI Library** built in Luau for game script interfaces. The library follows a **modular component system** with centralized services, theme management, and automatic build processing.

### Key Components
- **`src/Init.lua`**: Main WindUI table initialization, exposes `CreateWindow()`, themes, and services (369 lines)
- **`src/modules/Creator.lua`**: Core UI creation engine with theming, localization, and Roblox service wrappers (716 lines)
- **`src/components/window/Init.lua`**: Main window management - handles layout, dragging, resizing
- **`src/elements/`**: UI components (Button, Toggle, Slider, etc.) - each returns `{New = function(config)}`
- **`src/themes/Init.lua`**: Color scheme system (Dark, Light, Rose themes) with hex color definitions
- **`src/config/Init.lua`**: Data persistence system with type-specific serializers (313 lines)

## Development Workflow

### Build System
```bash
# Development build with custom entry point
npm run dev INPUT_FILE=main.lua

# Production build (minified with darklua)
npm run build

# Live development with file watching + HTTP server
npm run example-live-build  # Uses main.lua + port 8642
```

**Build Pipeline:**
- `build/build.sh`: Bash script with dev/production modes, generates headers with version/date
- `build/darklua.config.json`: Minification config (removes comments, renames variables, bundles requires)
- `build/package.lua`: Auto-generated from package.json for metadata injection
- `dist/main.lua`: Final output with header + bundled code

### Development Environment
- **Aftman** for tool management: `rojo@7.3.0`, `darklua@0.17.1`, `lune@0.7.6`
- **Node.js** for build orchestration with `chokidar-cli` for file watching
- Entry points: `main.lua` (primary entry point for both loadstring and development)

## Code Patterns

### Component Architecture
All UI elements follow this pattern:
```lua
-- src/elements/ComponentName.lua
return {
    New = function(config)
        -- Component creation logic
        local element = {}
        element.Update = function(self, value) end  -- Standard update method
        return instanceObject, element  -- Return GUI instance + control object
    end
}
```

### Service Access Pattern
```lua
local cloneref = (cloneref or clonereference or function(instance) return instance end)
local ServiceName = cloneref(game:GetService("ServiceName"))
```
**Always use `cloneref`** - this is a Roblox exploit compatibility pattern.

### Creator Module Usage
```lua
local Creator = require("../../modules/Creator")
local New = Creator.New  -- UI creation function
local Tween = Creator.Tween  -- Animation helper
```

### Config System Integration
Elements with persistent state must implement:
```lua
config.Flag = "uniqueIdentifier"  -- For config saving
-- Parser in src/config/Init.lua handles serialization
```

### Element Loading System
Components are dynamically loaded via `src/elements/Init.lua`:
```lua
-- Elements registry loads modules and injects dependencies
Elements.Load(tbl, Container, Elements, Window, WindUI, OnElementCreateFunction, ElementsModule, UIScale, Tab)
-- Each element receives: Tab, ParentTable, Index, GlobalIndex, Parent, Window, WindUI, UIScale
```

## Critical Conventions

1. **Theme Integration**: All components must use `Creator.Theme` colors, never hardcoded colors
2. **Localization Support**: Text through `Creator.Localization:Get("key")` with auto-detection from `LocalizationService.SystemLocaleId`
3. **Icon System**: Uses Lucide icons via external CDN - `Icons.SetIconsType("lucide")` in Creator.lua
4. **Scale Awareness**: All sizing must respect `UIScale` parameter passed through component hierarchy
5. **Event Cleanup**: Components must implement proper signal disconnection via `Creator.Signals` tracking

## File Organization

- **`src/components/`**: Complex UI components (window, notifications, popups)
- **`src/elements/`**: Simple form elements with standardized API
- **`src/utils/`**: Utilities (Acrylic blur effects, service wrappers)
- **`tests/`**: Component stress tests and examples
- **`dist/`**: Build output (git-ignored, auto-generated)

## Integration Points

- **External Icon CDN**: `https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua`
- **HTTP Compatibility**: Auto-detects `http_request`, `syn.request`, or `game:HttpGetAsync()` for cross-executor support
- **Roblox Services**: Heavily integrates CoreGui, UserInputService, TweenService, LocalizationService
- **Config Persistence**: JSON-based with type-specific parsers for complex UI state (Colorpicker hex values, Dropdown selections)

## Common Debugging

- Use `main.lua` for component testing
- Check `dist/main.lua` for build issues  
- Theme problems: verify color usage in `src/themes/Init.lua`
- Component not loading: check `src/elements/Init.lua` registration