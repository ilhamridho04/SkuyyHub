# WindUI Copilot Instructions

## Architecture Overview

WindUI is a **Roblox UI Library** built in Luau for game script interfaces. The library follows a **modular component system** with centralized services and theme management.

### Key Components
- **`src/Init.lua`**: Main entry point, bootstraps all modules and services
- **`src/modules/Creator.lua`**: Core UI creation engine with theming, localization, and Roblox service wrappers
- **`src/components/window/Init.lua`**: Main window management (1800+ lines - handles layout, dragging, resizing)
- **`src/elements/`**: UI components (Button, Toggle, Slider, etc.) - each returns `{New = function(config)}`
- **`src/themes/Init.lua`**: Color scheme system (Dark, Light, Rose, Plant themes)
- **`src/config/Init.lua`**: Data persistence system with type-specific serializers

## Development Workflow

### Build System
```bash
# Development build with hot reload
npm run dev INPUT_FILE=main_example.lua

# Production build (minified with darklua)
npm run build

# Live development with file watching
npm run example-live-build
```

**Key Build Files:**
- `build/build.sh`: Bash script handling dev/production modes with darklua processing
- `build/darklua.config.json`: Minification config (removes comments, renames variables, bundles requires)
- `build/package.lua`: Auto-generated from package.json for version injection

### Development Environment
- **Aftman** for tool management (rojo, darklua, lune)
- **darklua** for bundling and minification
- Entry points: `main.lua` (production), `main_example.lua` (development)

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

## Critical Conventions

1. **Theme Integration**: All components must use `Creator.Theme` colors, never hardcoded colors
2. **Localization Support**: Text through `Creator.Localization:Get("key")` 
3. **Icon System**: Uses Lucide icons via external CDN (`src/modules/Creator.lua:12`)
4. **Scale Awareness**: All sizing must respect `UIScale` parameter
5. **Event Cleanup**: Components must implement proper signal disconnection

## File Organization

- **`src/components/`**: Complex UI components (window, notifications, popups)
- **`src/elements/`**: Simple form elements with standardized API
- **`src/utils/`**: Utilities (Acrylic blur effects, service wrappers)
- **`tests/`**: Component stress tests and examples
- **`dist/`**: Build output (git-ignored, auto-generated)

## Integration Points

- **External Icon CDN**: `https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua`
- **HTTP Compatibility**: Supports both `game:HttpGetAsync()` and exploit HTTP functions
- **Roblox Services**: Heavily integrates CoreGui, UserInputService, TweenService
- **Config Persistence**: File-based config system with JSON serialization

## Common Debugging

- Use `main_example.lua` for component testing
- Check `dist/main.lua` for build issues  
- Theme problems: verify color usage in `src/themes/Init.lua`
- Component not loading: check `src/elements/Init.lua` registration