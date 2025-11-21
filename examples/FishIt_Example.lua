-- FishIt Game Script Example
-- Load WindUI with FishIt game features

getgenv().WindUI = loadstring(game:HttpGet("https://ai.ngodingskuyy.dev/dist/main.lua"))()

-- Check if the current game is supported
local gameInfo = WindUI:GetGameInfo()
print("Game Info:", gameInfo.Name, gameInfo.Id, gameInfo.Supported)

if gameInfo.Supported then
    -- Load game-specific features
    local success, message = WindUI:LoadGameScript()
    
    if success then
        print("✅ " .. message)
        WindUI:Notify({
            Title = "Script Loaded",
            Content = "FishIt features loaded successfully!",
            Duration = 5,
            Image = "check-circle"
        })
    else
        print("❌ " .. message)
        WindUI:Notify({
            Title = "Load Error",
            Content = message,
            Duration = 5,
            Image = "x-circle"
        })
    end
else
    -- Create a basic window for unsupported games
    local Window = WindUI:CreateWindow({
        Title = "SkuyyHub",
        Subtitle = "Game not supported",
        Size = UDim2.fromOffset(580, 460),
        KeySystem = false,
        LoadingTitle = "SkuyyHub",
        LoadingSubtitle = "Universal Script Hub",
    })
    
    local MainTab = Window:CreateTab({
        Name = "Info",
        Icon = "info"
    })
    
    MainTab:CreateParagraph({
        Title = "Unsupported Game",
        Content = "This game is not currently supported.\n\nGame: " .. (gameInfo.Name or "Unknown") .. "\nID: " .. gameInfo.Id .. "\n\nSupported Games:\n• FishIt (16732694052)"
    })
    
    WindUI:Notify({
        Title = "Unsupported Game",
        Content = "Current game is not supported by SkuyyHub",
        Duration = 8,
        Image = "alert-triangle"
    })
end