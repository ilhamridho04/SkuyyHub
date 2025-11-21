-- Advanced Game Detection and Loading System
local Games = {}

-- Services for detection
local cloneref = (cloneref or clonereference or function(instance) return instance end)
local Players = cloneref(game:GetService("Players"))
local Workspace = cloneref(game:GetService("Workspace"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
local LocalPlayer = Players.LocalPlayer

-- Game detection patterns for different games
local GameDetectionPatterns = {
    FishIt = {
        -- Place ID patterns (fallback)
        placeIds = {
            "16732694052", "16732694053", "16732694054", "16732694055", "16732694056"
        },
        
        -- Game name patterns
        namePatterns = {
            "fish.*it", "fishit", "fish.*simulator", "fishing.*simulator", "fish.*game"
        },
        
        -- Workspace object patterns
        workspaceObjects = {
            "FishingAreas", "FishSpots", "Fishing", "FishZones", "FishingZones",
            "Boats", "Harbor", "Pier", "Dock", "Ocean", "Sea", "Lake", "Pond",
            "Shop", "Shops", "Market", "Store", "ShopNPCs"
        },
        
        -- ReplicatedStorage patterns
        replicatedObjects = {
            "FishingRemotes", "Remotes", "FishData", "FishingData", "PlayerData",
            "GameData", "ShopData", "BoatData", "Events"
        },
        
        -- GUI patterns (PlayerGui)
        guiPatterns = {
            "FishingGui", "FishingUI", "FishGui", "MainGui", "GameGui",
            "ShopGui", "ShopUI", "InventoryGui", "StatsGui"
        },
        
        -- Tool patterns
        toolPatterns = {
            "rod", "fishingrod", "fishing.*rod", "bait", "net", "tackle"
        },
        
        -- Script/LocalScript patterns
        scriptPatterns = {
            "fishing", "fish", "boat", "shop", "inventory", "player"
        },
        
        -- Game creator patterns
        creatorPatterns = {
            -- Add known creator names if available
        }
    }
}

-- Get current game ID
local function GetGameId()
    return tostring(game.PlaceId)
end

-- Advanced game detection function
local function DetectGame()
    print("🔍 Starting advanced game detection...")
    
    -- Method 1: Place ID Detection (fastest)
    local gameId = GetGameId()
    print("   📋 Place ID:", gameId)
    
    for gameName, patterns in pairs(GameDetectionPatterns) do
        for _, id in pairs(patterns.placeIds or {}) do
            if gameId == id then
                print("   ✅ Detected", gameName, "via Place ID")
                return gameName
            end
        end
    end
    
    -- Method 2: Game Name Detection
    local gameInfo = nil
    pcall(function()
        gameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    
    if gameInfo and gameInfo.Name then
        print("   🎮 Game Name:", gameInfo.Name)
        
        for gameName, patterns in pairs(GameDetectionPatterns) do
            for _, pattern in pairs(patterns.namePatterns or {}) do
                if gameInfo.Name:lower():match(pattern:lower()) then
                    print("   ✅ Detected", gameName, "via Game Name pattern:", pattern)
                    return gameName
                end
            end
        end
    end
    
    -- Method 3: Workspace Object Detection
    print("   🌍 Scanning Workspace objects...")
    local workspaceChildren = Workspace:GetChildren()
    
    for gameName, patterns in pairs(GameDetectionPatterns) do
        local matchCount = 0
        local totalPatterns = #(patterns.workspaceObjects or {})
        
        for _, pattern in pairs(patterns.workspaceObjects or {}) do
            for _, obj in pairs(workspaceChildren) do
                if obj.Name:lower():match(pattern:lower()) or obj.Name:lower():find(pattern:lower()) then
                    matchCount = matchCount + 1
                    print("     🎯 Found workspace object:", obj.Name, "matches", pattern)
                    break
                end
            end
        end
        
        -- If we found at least 2 matching objects, consider it a match
        if matchCount >= 2 and totalPatterns > 0 then
            print("   ✅ Detected", gameName, "via Workspace objects (", matchCount, "/", totalPatterns, "matches)")
            return gameName
        end
    end
    
    -- Method 4: ReplicatedStorage Detection
    print("   📦 Scanning ReplicatedStorage...")
    local replicatedChildren = ReplicatedStorage:GetChildren()
    
    for gameName, patterns in pairs(GameDetectionPatterns) do
        local matchCount = 0
        local totalPatterns = #(patterns.replicatedObjects or {})
        
        for _, pattern in pairs(patterns.replicatedObjects or {}) do
            for _, obj in pairs(replicatedChildren) do
                if obj.Name:lower():match(pattern:lower()) or obj.Name:lower():find(pattern:lower()) then
                    matchCount = matchCount + 1
                    print("     🎯 Found replicated object:", obj.Name, "matches", pattern)
                    break
                end
            end
        end
        
        -- If we found at least 1 matching object, consider it a match
        if matchCount >= 1 and totalPatterns > 0 then
            print("   ✅ Detected", gameName, "via ReplicatedStorage (", matchCount, "/", totalPatterns, "matches)")
            return gameName
        end
    end
    
    -- Method 5: GUI Detection
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        print("   🖥️ Scanning PlayerGui...")
        local playerGui = LocalPlayer.PlayerGui
        
        for gameName, patterns in pairs(GameDetectionPatterns) do
            local matchCount = 0
            local totalPatterns = #(patterns.guiPatterns or {})
            
            for _, pattern in pairs(patterns.guiPatterns or {}) do
                for _, gui in pairs(playerGui:GetChildren()) do
                    if gui.Name:lower():match(pattern:lower()) or gui.Name:lower():find(pattern:lower()) then
                        matchCount = matchCount + 1
                        print("     🎯 Found GUI:", gui.Name, "matches", pattern)
                        break
                    end
                end
            end
            
            if matchCount >= 1 and totalPatterns > 0 then
                print("   ✅ Detected", gameName, "via PlayerGui (", matchCount, "/", totalPatterns, "matches)")
                return gameName
            end
        end
    end
    
    -- Method 6: Tool Detection (if player has character)
    if LocalPlayer and LocalPlayer:FindFirstChild("Character") then
        print("   🔧 Scanning Character tools...")
        local character = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        
        for gameName, patterns in pairs(GameDetectionPatterns) do
            local matchCount = 0
            
            -- Check tools in character
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, pattern in pairs(patterns.toolPatterns or {}) do
                        if tool.Name:lower():match(pattern:lower()) or tool.Name:lower():find(pattern:lower()) then
                            matchCount = matchCount + 1
                            print("     🎯 Found character tool:", tool.Name, "matches", pattern)
                            break
                        end
                    end
                end
            end
            
            -- Check tools in backpack
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, pattern in pairs(patterns.toolPatterns or {}) do
                            if tool.Name:lower():match(pattern:lower()) or tool.Name:lower():find(pattern:lower()) then
                                matchCount = matchCount + 1
                                print("     🎯 Found backpack tool:", tool.Name, "matches", pattern)
                                break
                            end
                        end
                    end
                end
            end
            
            if matchCount >= 1 then
                print("   ✅ Detected", gameName, "via Tools (", matchCount, "matches)")
                return gameName
            end
        end
    end
    
    -- Method 7: Deep Workspace Scanning (more intensive)
    print("   🔍 Deep workspace scanning...")
    local function scanFolder(folder, depth, maxDepth)
        if depth > maxDepth then return 0 end
        
        local matches = 0
        for _, obj in pairs(folder:GetChildren()) do
            -- Check object name
            for gameName, patterns in pairs(GameDetectionPatterns) do
                for _, pattern in pairs(patterns.workspaceObjects or {}) do
                    if obj.Name:lower():find(pattern:lower()) then
                        matches = matches + 1
                        print("     🎯 Deep scan found:", obj.Name, "at depth", depth)
                    end
                end
            end
            
            -- Recursively scan folders
            if obj:IsA("Folder") or obj:IsA("Model") then
                matches = matches + scanFolder(obj, depth + 1, maxDepth)
            end
        end
        return matches
    end
    
    local deepMatches = scanFolder(Workspace, 0, 2) -- Max depth 2 to avoid lag
    if deepMatches >= 3 then
        print("   ✅ Detected FishIt via deep scanning (", deepMatches, "matches)")
        return "FishIt" -- Default to FishIt if we find fishing-related objects
    end
    
    print("   ❌ No game detected via advanced patterns")
    return nil
end

-- Get game name with advanced detection
local function GetGameName()
    return DetectGame()
end

-- Load game-specific script
function Games.LoadGame(WindUI)
    local gameName = GetGameName()
    
    if not gameName then
        return false, "Unsupported Game"
    end
    
    local success, gameModule = pcall(function()
        return require(script:FindFirstChild(gameName))
    end)
    
    if success and gameModule then
        return gameModule.Load(WindUI)
    else
        return false, "Failed to load game: " .. (gameName or "Unknown")
    end
end

-- Dynamic detection cache
local DetectionCache = {
    lastCheck = 0,
    cacheDuration = 10, -- Cache for 10 seconds
    cachedResult = nil,
    detectionAttempts = 0
}

-- Enhanced detection with caching and retries
local function GetGameNameCached()
    local currentTime = tick()
    
    -- Use cache if still valid
    if DetectionCache.cachedResult and (currentTime - DetectionCache.lastCheck) < DetectionCache.cacheDuration then
        return DetectionCache.cachedResult
    end
    
    -- Try detection
    DetectionCache.detectionAttempts = DetectionCache.detectionAttempts + 1
    print("🔄 Game detection attempt #" .. DetectionCache.detectionAttempts)
    
    local detectedGame = DetectGame()
    
    -- Update cache
    DetectionCache.lastCheck = currentTime
    DetectionCache.cachedResult = detectedGame
    
    return detectedGame
end

-- Retry detection with different strategies
local function RetryDetection()
    print("🔄 Retrying detection with different strategies...")
    
    -- Wait for game to load more elements
    wait(2)
    
    -- Try detection again
    DetectionCache.cachedResult = nil -- Clear cache
    return GetGameNameCached()
end

-- Enhanced game name getter with retries
local function GetGameName()
    local result = GetGameNameCached()
    
    -- If no result and we haven't tried many times, retry
    if not result and DetectionCache.detectionAttempts < 3 then
        print("⏳ No game detected, retrying...")
        result = RetryDetection()
    end
    
    return result
end

-- Load game-specific script
function Games.LoadGame(WindUI)
    local gameName = GetGameName()
    
    if not gameName then
        return false, "Unsupported Game - Advanced detection couldn't identify this game"
    end
    
    local success, gameModule = pcall(function()
        return require(script:FindFirstChild(gameName))
    end)
    
    if success and gameModule then
        print("📦 Loading", gameName, "module...")
        return gameModule.Load(WindUI)
    else
        return false, "Failed to load game module: " .. (gameName or "Unknown")
    end
end

-- Check if current game is supported
function Games.IsSupported()
    return GetGameName() ~= nil
end

-- Get current game info with detection details
function Games.GetGameInfo()
    local gameName = GetGameName()
    local gameId = GetGameId()
    
    return {
        Name = gameName,
        Id = gameId,
        Supported = gameName ~= nil,
        DetectionAttempts = DetectionCache.detectionAttempts,
        LastCheck = DetectionCache.lastCheck,
        CacheValid = DetectionCache.cachedResult ~= nil
    }
end

-- Force refresh detection (clear cache)
function Games.RefreshDetection()
    print("🔄 Forcing detection refresh...")
    DetectionCache.cachedResult = nil
    DetectionCache.lastCheck = 0
    DetectionCache.detectionAttempts = 0
    
    return GetGameName()
end

-- Add more specific patterns for FishIt based on common fishing game elements
local function EnhanceFishItDetection()
    -- Add more patterns based on actual game observation
    local extraPatterns = {
        -- Common fishing game workspace objects
        workspaceExtraObjects = {
            "Water", "Beach", "Shore", "Marina", "Port", "Wharf",
            "FishingSpot", "CatchArea", "BaitShop", "TackleShop",
            "Rod", "Reel", "Line", "Hook", "Sinker", "Float",
            "Spawns", "SpawnLocation", "Teleports", "Areas"
        },
        
        -- Common GUI elements in fishing games
        guiExtraPatterns = {
            "CatchGui", "BaitGui", "RodGui", "ReelGui", "FishingBar",
            "ProgressBar", "CastingGui", "InventoryFrame", "ShopFrame",
            "StatsFrame", "LeaderboardGui"
        },
        
        -- Common remote/event names
        remotePatterns = {
            "CastRod", "ReelIn", "Catch", "BuyItem", "SellFish",
            "EquipRod", "UseBait", "StartFishing", "StopFishing"
        }
    }
    
    -- Merge extra patterns
    if GameDetectionPatterns.FishIt then
        for key, patterns in pairs(extraPatterns) do
            if GameDetectionPatterns.FishIt.workspaceObjects and key == "workspaceExtraObjects" then
                for _, pattern in pairs(patterns) do
                    table.insert(GameDetectionPatterns.FishIt.workspaceObjects, pattern)
                end
            elseif GameDetectionPatterns.FishIt.guiPatterns and key == "guiExtraPatterns" then
                for _, pattern in pairs(patterns) do
                    table.insert(GameDetectionPatterns.FishIt.guiPatterns, pattern)
                end
            end
        end
    end
end

-- Initialize enhanced detection
EnhanceFishItDetection()

-- Background detection service (optional)
spawn(function()
    while wait(30) do -- Check every 30 seconds
        if not DetectionCache.cachedResult then
            print("🔍 Background detection check...")
            GetGameNameCached()
        end
    end
end)

return Games