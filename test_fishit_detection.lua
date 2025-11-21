-- Advanced FishIt Game Detection Test
-- This script tests the new dynamic detection system

local WindUI = require("./src/Init")

print("=== Advanced FishIt Detection Test ===")
print()

-- Test initial game info
local gameInfo = WindUI:GetGameInfo()
print("🎮 Initial Game Information:")
print("   Name:", gameInfo.Name or "Unknown")
print("   Place ID:", gameInfo.Id or "Unknown")
print("   Supported:", gameInfo.Supported and "✅ Yes" or "❌ No")
print("   Detection Attempts:", gameInfo.DetectionAttempts or 0)
print("   Cache Valid:", gameInfo.CacheValid and "Yes" or "No")
print()

-- Test environment scanning
print("🔍 Environment Scanning:")
print("   Place ID:", game.PlaceId)

-- Get game name from Marketplace
local marketplaceService = game:GetService("MarketplaceService")
local gameData = nil
pcall(function()
    gameData = marketplaceService:GetProductInfo(game.PlaceId)
end)
if gameData then
    print("   Game Name:", gameData.Name)
    print("   Creator:", gameData.Creator and gameData.Creator.Name or "Unknown")
end

-- Scan Workspace
print("\n🌍 Workspace Analysis:")
local workspaceObjects = game.Workspace:GetChildren()
print("   Total Objects:", #workspaceObjects)
print("   Sample Objects:")
for i = 1, math.min(10, #workspaceObjects) do
    local obj = workspaceObjects[i]
    print("     •", obj.Name, "(" .. obj.ClassName .. ")")
end

-- Check for fishing-related objects
local fishingTerms = {"fish", "rod", "boat", "water", "sea", "ocean", "lake", "bait", "tackle", "dock", "pier", "harbor"}
local foundFishingObjects = {}
for _, obj in pairs(workspaceObjects) do
    local objName = obj.Name:lower()
    for _, term in pairs(fishingTerms) do
        if objName:find(term) then
            table.insert(foundFishingObjects, obj.Name)
            break
        end
    end
end

if #foundFishingObjects > 0 then
    print("\n🎣 Fishing-Related Objects Found:")
    for _, objName in pairs(foundFishingObjects) do
        print("     ✅", objName)
    end
else
    print("\n❌ No obvious fishing-related objects found")
end

-- Scan ReplicatedStorage
print("\n📦 ReplicatedStorage Analysis:")
local replicatedObjects = game.ReplicatedStorage:GetChildren()
print("   Total Objects:", #replicatedObjects)
print("   Sample Objects:")
for i = 1, math.min(5, #replicatedObjects) do
    local obj = replicatedObjects[i]
    print("     •", obj.Name, "(" .. obj.ClassName .. ")")
end

-- Check PlayerGui
local player = game.Players.LocalPlayer
if player and player:FindFirstChild("PlayerGui") then
    print("\n🖥️ PlayerGui Analysis:")
    local guiObjects = player.PlayerGui:GetChildren()
    print("   Total GUIs:", #guiObjects)
    print("   GUI Objects:")
    for i = 1, math.min(5, #guiObjects) do
        local obj = guiObjects[i]
        print("     •", obj.Name, "(" .. obj.ClassName .. ")")
    end
end

-- Test forced detection refresh
print("\n🔄 Testing Forced Detection Refresh:")
if WindUI.Games and WindUI.Games.RefreshDetection then
    local refreshResult = WindUI.Games.RefreshDetection()
    print("   Refresh Result:", refreshResult or "nil")
    
    local newGameInfo = WindUI:GetGameInfo()
    print("   Updated Name:", newGameInfo.Name or "Unknown")
    print("   Updated Supported:", newGameInfo.Supported and "✅ Yes" or "❌ No")
    print("   New Attempts:", newGameInfo.DetectionAttempts or 0)
else
    print("   ❌ Refresh function not available")
end

-- Final assessment
print("\n📊 Detection Assessment:")
local finalGameInfo = WindUI:GetGameInfo()
local isFishIt = finalGameInfo.Name == "FishIt" and finalGameInfo.Supported

if isFishIt then
    print("✅ FishIt Successfully Detected!")
    print("🚀 Testing script loading...")
    
    local success, message = WindUI:LoadGameScript()
    print("   Load Result:", success and "✅ Success" or "❌ Failed")
    print("   Message:", message)
else
    print("❌ FishIt Not Detected")
    print("💡 Possible reasons:")
    print("   • Game might not be FishIt")
    print("   • Game still loading")
    print("   • Detection patterns need updating")
    print("   • Place ID not in database")
    
    if #foundFishingObjects > 0 then
        print("   • But fishing objects were found - might be fishing game")
    end
end

print("\n🔧 Debug Suggestions:")
if not isFishIt then
    print("   1. Check if you're in the correct FishIt game")
    print("   2. Wait for game to fully load and retry")
    print("   3. Use 'Debug Detection Info' in UI for more details")
    print("   4. Report Place ID and game name to developers")
end

print("\n=== Advanced Test Complete ===")
print("📝 Place ID for reference:", game.PlaceId)