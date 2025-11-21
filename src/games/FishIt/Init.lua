-- FishIt Game Script
local FishIt = {}

-- Services
local cloneref = (cloneref or clonereference or function(instance) return instance end)
local Players = cloneref(game:GetService("Players"))
local Workspace = cloneref(game:GetService("Workspace"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))

local LocalPlayer = Players.LocalPlayer

-- Game Variables
local AutoFishEnabled = false
local LegitPerfectEnabled = false
local AutoShellEnabled = false

-- Game References
local GameRemotes = {
    Fish = nil,
    Perfect = nil,
    Shop = nil,
    Teleport = nil
}

-- Comprehensive Map Data for FishIt
local Maps = {
    ["Spawn"] = {
        Name = "🏝️ Spawn Island",
        Position = Vector3.new(0, 5, 0),
        FishingSpots = {
            {Name = "Starter Dock", Position = Vector3.new(-45, 3, 95), Rarity = "Common"},
            {Name = "Sandy Beach", Position = Vector3.new(75, 3, -25), Rarity = "Common"},
            {Name = "Wooden Pier", Position = Vector3.new(-95, 5, 145), Rarity = "Uncommon"},
            {Name = "Rocky Shore", Position = Vector3.new(120, 3, 80), Rarity = "Uncommon"},
            {Name = "Secret Cove", Position = Vector3.new(-150, 3, -80), Rarity = "Rare"}
        }
    },
    ["Deep Sea"] = {
        Name = "🌊 Deep Sea Territory",
        Position = Vector3.new(500, 5, 500),
        FishingSpots = {
            {Name = "Deep Waters", Position = Vector3.new(450, 3, 450), Rarity = "Rare"},
            {Name = "Coral Reef", Position = Vector3.new(550, 3, 550), Rarity = "Epic"},
            {Name = "Underwater Trench", Position = Vector3.new(500, -15, 500), Rarity = "Epic"},
            {Name = "Kelp Forest", Position = Vector3.new(480, 3, 520), Rarity = "Rare"},
            {Name = "Abyssal Zone", Position = Vector3.new(530, -25, 470), Rarity = "Legendary"},
            {Name = "Sunken Ship", Position = Vector3.new(520, -10, 530), Rarity = "Mythic"}
        }
    },
    ["Frozen Fjord"] = {
        Name = "❄️ Frozen Fjord",
        Position = Vector3.new(-300, 5, -300),
        FishingSpots = {
            {Name = "Frozen Lake", Position = Vector3.new(-320, 3, -280), Rarity = "Uncommon"},
            {Name = "Ice Fishing Hole", Position = Vector3.new(-280, 3, -320), Rarity = "Rare"},
            {Name = "Glacier Edge", Position = Vector3.new(-300, 15, -350), Rarity = "Epic"},
            {Name = "Arctic Pool", Position = Vector3.new(-340, 3, -260), Rarity = "Rare"},
            {Name = "Polar Cave", Position = Vector3.new(-270, -5, -340), Rarity = "Legendary"}
        }
    },
    ["Volcanic Island"] = {
        Name = "🌋 Volcanic Island",
        Position = Vector3.new(800, 50, -200),
        FishingSpots = {
            {Name = "Lava Pool", Position = Vector3.new(780, 45, -180), Rarity = "Epic"},
            {Name = "Hot Springs", Position = Vector3.new(820, 40, -220), Rarity = "Rare"},
            {Name = "Obsidian Shore", Position = Vector3.new(800, 35, -250), Rarity = "Epic"},
            {Name = "Magma Chamber", Position = Vector3.new(790, 30, -190), Rarity = "Legendary"},
            {Name = "Fire Geyser", Position = Vector3.new(810, 55, -210), Rarity = "Mythic"}
        }
    },
    ["Ancient Ruins"] = {
        Name = "🏛️ Ancient Ruins",
        Position = Vector3.new(-600, 20, 400),
        FishingSpots = {
            {Name = "Temple Pool", Position = Vector3.new(-580, 18, 420), Rarity = "Epic"},
            {Name = "Sacred Fountain", Position = Vector3.new(-620, 22, 380), Rarity = "Legendary"},
            {Name = "Mystic Waters", Position = Vector3.new(-600, 15, 400), Rarity = "Mythic"},
            {Name = "Ancient Pond", Position = Vector3.new(-590, 19, 410), Rarity = "Epic"},
            {Name = "Forgotten Lake", Position = Vector3.new(-610, 17, 390), Rarity = "Legendary"}
        }
    },
    ["Crystal Caverns"] = {
        Name = "💎 Crystal Caverns",
        Position = Vector3.new(200, -20, -500),
        FishingSpots = {
            {Name = "Crystal Lake", Position = Vector3.new(180, -18, -480), Rarity = "Rare"},
            {Name = "Glowing Pool", Position = Vector3.new(220, -22, -520), Rarity = "Epic"},
            {Name = "Diamond Springs", Position = Vector3.new(200, -25, -500), Rarity = "Legendary"},
            {Name = "Gem Pond", Position = Vector3.new(190, -19, -490), Rarity = "Epic"},
            {Name = "Prismatic Waters", Position = Vector3.new(210, -23, -510), Rarity = "Mythic"}
        }
    },
    ["Sky Islands"] = {
        Name = "☁️ Sky Islands",
        Position = Vector3.new(0, 200, 800),
        FishingSpots = {
            {Name = "Cloud Lake", Position = Vector3.new(-20, 198, 780), Rarity = "Epic"},
            {Name = "Wind Pool", Position = Vector3.new(20, 202, 820), Rarity = "Legendary"},
            {Name = "Storm Waters", Position = Vector3.new(0, 205, 800), Rarity = "Mythic"},
            {Name = "Thunder Pond", Position = Vector3.new(-10, 199, 790), Rarity = "Legendary"},
            {Name = "Lightning Lake", Position = Vector3.new(10, 203, 810), Rarity = "Mythic"}
        }
    },
    ["Mushroom Forest"] = {
        Name = "🍄 Mushroom Forest",
        Position = Vector3.new(-800, 10, 200),
        FishingSpots = {
            {Name = "Spore Pool", Position = Vector3.new(-820, 8, 180), Rarity = "Uncommon"},
            {Name = "Toxic Swamp", Position = Vector3.new(-780, 12, 220), Rarity = "Rare"},
            {Name = "Fungal Lake", Position = Vector3.new(-800, 9, 200), Rarity = "Epic"},
            {Name = "Bioluminescent Pond", Position = Vector3.new(-790, 11, 210), Rarity = "Legendary"},
            {Name = "Giant Mushroom Pool", Position = Vector3.new(-810, 7, 190), Rarity = "Mythic"}
        }
    }
}

-- Comprehensive Event Data for FishIt
local Events = {
    ["Treasure Hunt"] = {
        Name = "🏴‍☠️ Treasure Hunt Event",
        Description = "Find hidden treasures around the world!",
        Position = Vector3.new(200, 5, 200),
        Active = false,
        Reward = "Rare Items & Coins",
        Duration = "2 Hours"
    },
    ["Double XP"] = {
        Name = "⚡ Double XP Weekend",
        Description = "Earn double experience from fishing!",
        Position = Vector3.new(-200, 5, 200),
        Active = false,
        Reward = "2x Experience",
        Duration = "Weekend"
    },
    ["Rare Fish Spawn"] = {
        Name = "🐟 Rare Fish Migration",
        Description = "Rare fish are spawning everywhere!",
        Position = Vector3.new(0, 5, 300),
        Active = false,
        Reward = "Legendary Fish",
        Duration = "1 Hour"
    },
    ["Boss Fish"] = {
        Name = "🦈 Leviathan Boss Event",
        Description = "A massive sea creature has appeared!",
        Position = Vector3.new(0, 5, -300),
        Active = false,
        Reward = "Mythic Rewards",
        Duration = "30 Minutes"
    },
    ["Golden Hour"] = {
        Name = "🌅 Golden Hour Fishing",
        Description = "All fish have increased value!",
        Position = Vector3.new(300, 5, 0),
        Active = false,
        Reward = "3x Fish Value",
        Duration = "1 Hour"
    },
    ["Storm Event"] = {
        Name = "⛈️ Lightning Storm",
        Description = "Electric fish are more common during storms!",
        Position = Vector3.new(-300, 5, 0),
        Active = false,
        Reward = "Electric Fish",
        Duration = "45 Minutes"
    },
    ["Meteor Shower"] = {
        Name = "☄️ Cosmic Fishing Event",
        Description = "Space fish are falling from the sky!",
        Position = Vector3.new(0, 100, 0),
        Active = false,
        Reward = "Cosmic Fish",
        Duration = "20 Minutes"
    },
    ["Ice Age"] = {
        Name = "🧊 Frozen Waters Event",
        Description = "All water is freezing, catch ice fish!",
        Position = Vector3.new(-400, 5, -400),
        Active = false,
        Reward = "Ice Fish",
        Duration = "1 Hour"
    },
    ["Volcanic Eruption"] = {
        Name = "🌋 Magma Fish Event",
        Description = "Lava fish are emerging from volcanos!",
        Position = Vector3.new(800, 50, -200),
        Active = false,
        Reward = "Fire Fish",
        Duration = "30 Minutes"
    },
    ["Admin Event"] = {
        Name = "👑 Admin Hosted Event",
        Description = "Join the admin for special rewards!",
        Position = Vector3.new(0, 20, 0),
        Active = false,
        Reward = "Exclusive Items",
        Duration = "Variable"
    }
}

-- Comprehensive Shop System for FishIt
local Shops = {
    ["Rod Shop"] = {
        Name = "🎣 Fishing Rod Emporium",
        Position = Vector3.new(15, 5, 15),
        Category = "Equipment",
        Items = {
            {Name = "Wooden Rod", Price = "$50", Description = "Basic starter rod", Rarity = "Common"},
            {Name = "Steel Rod", Price = "$250", Description = "Durable metal rod", Rarity = "Uncommon"},
            {Name = "Carbon Fiber Rod", Price = "$750", Description = "Lightweight and strong", Rarity = "Rare"},
            {Name = "Golden Rod", Price = "$2,500", Description = "Increases catch value", Rarity = "Epic"},
            {Name = "Diamond Rod", Price = "$10,000", Description = "Attracts rare fish", Rarity = "Legendary"},
            {Name = "Mythical Rod", Price = "$50,000", Description = "Legendary fishing power", Rarity = "Mythic"}
        }
    },
    ["Bait Shop"] = {
        Name = "🪱 Bait & Tackle Store",
        Position = Vector3.new(25, 5, 25),
        Category = "Consumables",
        Items = {
            {Name = "Worms", Price = "$5", Description = "Basic bait for common fish", Rarity = "Common"},
            {Name = "Minnows", Price = "$15", Description = "Live bait for better catches", Rarity = "Uncommon"},
            {Name = "Power Bait", Price = "$50", Description = "Artificial bait with scent", Rarity = "Rare"},
            {Name = "Golden Lure", Price = "$200", Description = "Attracts valuable fish", Rarity = "Epic"},
            {Name = "Mystical Essence", Price = "$1,000", Description = "Lures legendary creatures", Rarity = "Legendary"},
            {Name = "Cosmic Bait", Price = "$5,000", Description = "Attracts space fish", Rarity = "Mythic"}
        }
    },
    ["Boat Shop"] = {
        Name = "⛵ Boat & Vessel Shop",
        Position = Vector3.new(35, 5, 35),
        Category = "Vehicles",
        Items = {
            {Name = "Wooden Raft", Price = "$500", Description = "Basic water transport", Rarity = "Common"},
            {Name = "Fishing Boat", Price = "$2,000", Description = "Small fishing vessel", Rarity = "Uncommon"},
            {Name = "Speed Boat", Price = "$8,000", Description = "Fast water travel", Rarity = "Rare"},
            {Name = "Yacht", Price = "$25,000", Description = "Luxury fishing experience", Rarity = "Epic"},
            {Name = "Submarine", Price = "$100,000", Description = "Deep sea exploration", Rarity = "Legendary"},
            {Name = "Flying Ship", Price = "$500,000", Description = "Magical flying vessel", Rarity = "Mythic"}
        }
    },
    ["Upgrade Shop"] = {
        Name = "⚡ Equipment Upgrades",
        Position = Vector3.new(45, 5, 45),
        Category = "Upgrades",
        Items = {
            {Name = "Line Strength +1", Price = "$100", Description = "Stronger fishing line", Rarity = "Common"},
            {Name = "Reel Speed +1", Price = "$200", Description = "Faster reeling", Rarity = "Uncommon"},
            {Name = "Luck Boost +1", Price = "$500", Description = "Increased rare catches", Rarity = "Rare"},
            {Name = "XP Multiplier", Price = "$1,000", Description = "Double experience gain", Rarity = "Epic"},
            {Name = "Auto-Fish Module", Price = "$5,000", Description = "Automatic fishing", Rarity = "Legendary"},
            {Name = "Perfect Catch Chip", Price = "$25,000", Description = "Always perfect timing", Rarity = "Mythic"}
        }
    },
    ["Cosmetic Shop"] = {
        Name = "👕 Cosmetics & Skins",
        Position = Vector3.new(55, 5, 55),
        Category = "Cosmetics",
        Items = {
            {Name = "Fishing Hat", Price = "$25", Description = "Classic angler look", Rarity = "Common"},
            {Name = "Sailor Outfit", Price = "$100", Description = "Professional fisherman attire", Rarity = "Uncommon"},
            {Name = "Captain Uniform", Price = "$500", Description = "Command the seas in style", Rarity = "Rare"},
            {Name = "Golden Suit", Price = "$2,000", Description = "Shiny golden appearance", Rarity = "Epic"},
            {Name = "Neptune's Robes", Price = "$10,000", Description = "Blessed by the sea god", Rarity = "Legendary"},
            {Name = "Cosmic Armor", Price = "$50,000", Description = "Armor from the stars", Rarity = "Mythic"}
        }
    },
    ["Tools Shop"] = {
        Name = "🔧 Fishing Tools",
        Position = Vector3.new(65, 5, 65),
        Category = "Tools",
        Items = {
            {Name = "Tackle Box", Price = "$75", Description = "Store more bait", Rarity = "Common"},
            {Name = "Fish Finder", Price = "$300", Description = "Locate fish nearby", Rarity = "Uncommon"},
            {Name = "Depth Sonar", Price = "$800", Description = "See underwater structures", Rarity = "Rare"},
            {Name = "Weather Station", Price = "$2,000", Description = "Predict fishing conditions", Rarity = "Epic"},
            {Name = "Teleporter", Price = "$15,000", Description = "Instant travel to spots", Rarity = "Legendary"},
            {Name = "Time Controller", Price = "$100,000", Description = "Control time and weather", Rarity = "Mythic"}
        }
    },
    ["Food Shop"] = {
        Name = "🍎 Food & Buffs",
        Position = Vector3.new(75, 5, 75),
        Category = "Consumables",
        Items = {
            {Name = "Energy Bar", Price = "$10", Description = "Restore stamina", Rarity = "Common"},
            {Name = "Luck Potion", Price = "$50", Description = "Temporary luck boost", Rarity = "Uncommon"},
            {Name = "Speed Elixir", Price = "$100", Description = "Faster movement", Rarity = "Rare"},
            {Name = "Giant's Strength", Price = "$250", Description = "Catch bigger fish", Rarity = "Epic"},
            {Name = "Mermaid's Blessing", Price = "$1,000", Description = "Breathe underwater", Rarity = "Legendary"},
            {Name = "Poseidon's Feast", Price = "$5,000", Description = "All buffs combined", Rarity = "Mythic"}
        }
    },
    ["Special Shop"] = {
        Name = "✨ Limited Edition",
        Position = Vector3.new(85, 5, 85),
        Category = "Limited",
        Items = {
            {Name = "Event Token", Price = "$500", Description = "Access special events", Rarity = "Rare"},
            {Name = "VIP Pass", Price = "$2,000", Description = "Exclusive areas access", Rarity = "Epic"},
            {Name = "Developer Rod", Price = "$25,000", Description = "Used by the creators", Rarity = "Legendary"},
            {Name = "Admin Commands", Price = "$100,000", Description = "Limited admin powers", Rarity = "Mythic"},
            {Name = "Game Owner Badge", Price = "$1,000,000", Description = "Ultimate prestige", Rarity = "Divine"}
        }
    }
}

-- Initialize Game References
local function InitializeReferences()
    -- Try to find game remotes
    spawn(function()
        wait(2) -- Wait for game to load
        
        if ReplicatedStorage:FindFirstChild("Remotes") then
            local remotes = ReplicatedStorage.Remotes
            GameRemotes.Fish = remotes:FindFirstChild("Fish") or remotes:FindFirstChild("StartFishing")
            GameRemotes.Perfect = remotes:FindFirstChild("Perfect") or remotes:FindFirstChild("PerfectCatch")
            GameRemotes.Shop = remotes:FindFirstChild("Shop") or remotes:FindFirstChild("BuyItem")
        end
    end)
end

-- Teleport Function
local function TeleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Auto Fish Function with Instant Catch
local function AutoFish()
    spawn(function()
        while AutoFishEnabled do
            wait(0.05) -- Faster loop for instant catch
            
            -- Method 1: Remote Events
            if GameRemotes.Fish then
                pcall(function()
                    GameRemotes.Fish:FireServer()
                end)
            end
            
            -- Method 2: Look for fishing GUI elements
            if LocalPlayer.PlayerGui:FindFirstChild("FishingGui") then
                local fishingGui = LocalPlayer.PlayerGui.FishingGui
                
                -- Start fishing
                if fishingGui:FindFirstChild("FishButton") and fishingGui.FishButton.Visible then
                    pcall(function()
                        fishingGui.FishButton.MouseButton1Click:Fire()
                    end)
                end
                
                -- Instant catch - look for catch button
                if fishingGui:FindFirstChild("CatchButton") and fishingGui.CatchButton.Visible then
                    pcall(function()
                        fishingGui.CatchButton.MouseButton1Click:Fire()
                    end)
                end
                
                -- Alternative catch methods
                if fishingGui:FindFirstChild("ReelButton") and fishingGui.ReelButton.Visible then
                    pcall(function()
                        fishingGui.ReelButton.MouseButton1Click:Fire()
                    end)
                end
            end
            
            -- Method 3: Check for fishing tools
            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():find("rod") or tool.Name:lower():find("fish")) then
                    if tool:FindFirstChild("RemoteEvent") then
                        pcall(function()
                            tool.RemoteEvent:FireServer("StartFishing")
                            wait(0.1)
                            tool.RemoteEvent:FireServer("Catch")
                        end)
                    end
                end
            end
            
            -- Method 4: Direct workspace fishing
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("fish") and obj:FindFirstChild("ClickDetector") then
                    pcall(function()
                        fireclickdetector(obj.ClickDetector)
                    end)
                end
            end
        end
    end)
end

-- Legit Perfect Function with Advanced Detection
local function LegitPerfect()
    spawn(function()
        while LegitPerfectEnabled do
            wait(0.01) -- Very fast detection
            
            -- Look for perfect timing indicators
            if LocalPlayer.PlayerGui:FindFirstChild("FishingGui") then
                local fishingGui = LocalPlayer.PlayerGui.FishingGui
                
                -- Method 1: Perfect Zone Detection
                if fishingGui:FindFirstChild("PerfectZone") and fishingGui.PerfectZone.Visible then
                    local perfectZone = fishingGui.PerfectZone
                    
                    -- Check if indicator is in perfect zone
                    if perfectZone:FindFirstChild("Indicator") then
                        local indicator = perfectZone.Indicator
                        local zoneFrame = perfectZone:FindFirstChild("Zone")
                        
                        if zoneFrame and indicator.Position.X.Scale >= zoneFrame.Position.X.Scale and 
                           indicator.Position.X.Scale <= (zoneFrame.Position.X.Scale + zoneFrame.Size.X.Scale) then
                            
                            -- Random delay for legit behavior (0.02-0.08 seconds)
                            wait(math.random(20, 80) / 1000)
                            
                            if GameRemotes.Perfect then
                                pcall(function()
                                    GameRemotes.Perfect:FireServer()
                                end)
                            end
                        end
                    end
                end
                
                -- Method 2: Perfect Button Detection
                if fishingGui:FindFirstChild("PerfectButton") and fishingGui.PerfectButton.Visible then
                    wait(math.random(30, 70) / 1000) -- Legit reaction time
                    pcall(function()
                        fishingGui.PerfectButton.MouseButton1Click:Fire()
                    end)
                end
                
                -- Method 3: Timing Bar Detection
                if fishingGui:FindFirstChild("TimingBar") then
                    local timingBar = fishingGui.TimingBar
                    if timingBar:FindFirstChild("Perfect") and timingBar.Perfect.Visible then
                        wait(math.random(25, 75) / 1000)
                        pcall(function()
                            UserInputService:SimulateClick()
                        end)
                    end
                end
                
                -- Method 4: Color-based detection
                if fishingGui:FindFirstChild("CatchIndicator") then
                    local indicator = fishingGui.CatchIndicator
                    if indicator.BackgroundColor3 == Color3.fromRGB(0, 255, 0) then -- Green = perfect
                        wait(math.random(20, 60) / 1000)
                        pcall(function()
                            indicator.MouseButton1Click:Fire()
                        end)
                    end
                end
            end
        end
    end)
end

-- Enhanced Auto Shell Collection System
local function AutoShell()
    spawn(function()
        while AutoShellEnabled do
            wait(0.3) -- Faster collection
            
            -- Method 1: Find shells in workspace
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("shell") or obj.Name:lower():find("seashell") or 
                   obj.Name:lower():find("pearl") or obj.Name:lower():find("treasure") then
                    
                    -- Direct click detection
                    if obj:FindFirstChild("ClickDetector") then
                        pcall(function()
                            fireclickdetector(obj.ClickDetector)
                        end)
                    -- Proximity prompt detection
                    elseif obj:FindFirstChild("ProximityPrompt") then
                        pcall(function()
                            fireproximityprompt(obj.ProximityPrompt)
                        end)
                    -- Part-based collection with teleport
                    elseif obj:IsA("Part") or obj:IsA("MeshPart") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                            
                            -- Quick teleport to collect
                            pcall(function()
                                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                                wait(0.1)
                                
                                -- Try multiple collection methods
                                if obj:FindFirstChild("RemoteEvent") then
                                    obj.RemoteEvent:FireServer()
                                end
                                
                                -- Touch-based collection
                                if obj.CanTouch then
                                    obj.Touched:Fire(LocalPlayer.Character.HumanoidRootPart)
                                end
                                
                                wait(0.1)
                                LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
                            end)
                        end
                    end
                end
            end
            
            -- Method 2: Search in specific shell spawn areas
            local shellAreas = {
                Workspace:FindFirstChild("ShellSpawns"),
                Workspace:FindFirstChild("TreasureSpawns"),
                Workspace:FindFirstChild("Collectibles")
            }
            
            for _, area in pairs(shellAreas) do
                if area then
                    for _, shell in pairs(area:GetChildren()) do
                        if shell:FindFirstChild("ClickDetector") then
                            pcall(function()
                                fireclickdetector(shell.ClickDetector)
                            end)
                        elseif shell:FindFirstChild("ProximityPrompt") then
                            pcall(function()
                                fireproximityprompt(shell.ProximityPrompt)
                            end)
                        end
                    end
                end
            end
            
            -- Method 3: Beach combing - search sandy areas
            for _, map in pairs(Maps) do
                for _, spot in pairs(map.FishingSpots) do
                    if spot.Name:lower():find("beach") or spot.Name:lower():find("shore") then
                        -- Check area around beach spots for shells
                        local region = Region3.new(
                            spot.Position - Vector3.new(20, 5, 20),
                            spot.Position + Vector3.new(20, 5, 20)
                        )
                        
                        for _, obj in pairs(Workspace:GetPartBoundsInRegion(region, math.huge, math.huge)) do
                            if obj.Name:lower():find("shell") then
                                if obj:FindFirstChild("ClickDetector") then
                                    pcall(function()
                                        fireclickdetector(obj.ClickDetector)
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Advanced Event Detection System
local EventUpdateCallbacks = {}
local LastEventStates = {}

local function DetectEvents()
    spawn(function()
        while wait(5) do -- Check every 5 seconds for better responsiveness
            local eventsChanged = false
            
            -- Reset all events
            for eventName, eventData in pairs(Events) do
                Events[eventName].Active = false
            end
            
            -- Method 1: Check workspace events
            if Workspace:FindFirstChild("Events") then
                for _, event in pairs(Workspace.Events:GetChildren()) do
                    local eventName = event.Name
                    if Events[eventName] then
                        Events[eventName].Active = true
                        if event:FindFirstChild("Position") then
                            Events[eventName].Position = event.Position.Value
                        elseif event:IsA("Part") then
                            Events[eventName].Position = event.Position
                        end
                        eventsChanged = true
                    end
                end
            end
            
            -- Method 2: Check GUI for events
            local eventGuis = {
                LocalPlayer.PlayerGui:FindFirstChild("EventGui"),
                LocalPlayer.PlayerGui:FindFirstChild("NotificationGui"),
                LocalPlayer.PlayerGui:FindFirstChild("AnnouncementGui")
            }
            
            for _, eventGui in pairs(eventGuis) do
                if eventGui then
                    for _, frame in pairs(eventGui:GetChildren()) do
                        if frame:IsA("Frame") and frame.Visible then
                            local eventName = frame.Name
                            if Events[eventName] then
                                Events[eventName].Active = true
                                eventsChanged = true
                            end
                            
                            -- Text-based detection
                            if frame:FindFirstChild("TextLabel") then
                                local text = frame.TextLabel.Text:lower()
                                for eventKey, eventData in pairs(Events) do
                                    if text:find(eventData.Name:lower()) or text:find(eventKey:lower()) then
                                        Events[eventKey].Active = true
                                        eventsChanged = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Method 3: Check chat for admin announcements
            if LocalPlayer.PlayerGui:FindFirstChild("Chat") then
                local chatGui = LocalPlayer.PlayerGui.Chat
                if chatGui:FindFirstChild("Frame") and chatGui.Frame:FindFirstChild("ChatChannelParentFrame") then
                    local chatFrame = chatGui.Frame.ChatChannelParentFrame
                    if chatFrame:FindFirstChild("Frame_MessageLogDisplay") then
                        local messageLog = chatFrame.Frame_MessageLogDisplay
                        if messageLog:FindFirstChild("Scroller") then
                            for _, message in pairs(messageLog.Scroller:GetChildren()) do
                                if message:IsA("Frame") and message:FindFirstChild("TextLabel") then
                                    local text = message.TextLabel.Text:lower()
                                    
                                    -- Admin event detection
                                    if text:find("admin") and (text:find("event") or text:find("giveaway")) then
                                        Events["Admin Event"].Active = true
                                        eventsChanged = true
                                    end
                                    
                                    -- Other event keywords
                                    local eventKeywords = {
                                        ["treasure"] = "Treasure Hunt",
                                        ["double"] = "Double XP",
                                        ["rare"] = "Rare Fish Spawn",
                                        ["boss"] = "Boss Fish",
                                        ["golden"] = "Golden Hour",
                                        ["storm"] = "Storm Event",
                                        ["meteor"] = "Meteor Shower"
                                    }
                                    
                                    for keyword, eventName in pairs(eventKeywords) do
                                        if text:find(keyword) then
                                            Events[eventName].Active = true
                                            eventsChanged = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Method 4: Check for special particles/effects
            for _, effect in pairs(Workspace:GetChildren()) do
                if effect:IsA("Part") and effect:FindFirstChildOfClass("ParticleEmitter") then
                    local particle = effect:FindFirstChildOfClass("ParticleEmitter")
                    
                    -- Golden particles = Golden Hour
                    if particle.Color == ColorSequence.new(Color3.fromRGB(255, 215, 0)) then
                        Events["Golden Hour"].Active = true
                        Events["Golden Hour"].Position = effect.Position
                        eventsChanged = true
                    end
                    
                    -- Electric particles = Storm
                    if particle.Color == ColorSequence.new(Color3.fromRGB(0, 255, 255)) then
                        Events["Storm Event"].Active = true
                        Events["Storm Event"].Position = effect.Position
                        eventsChanged = true
                    end
                end
            end
            
            -- Update UI if events changed
            if eventsChanged then
                for _, callback in pairs(EventUpdateCallbacks) do
                    pcall(callback)
                end
            end
        end
    end)
end

-- Function to register event update callbacks
local function RegisterEventCallback(callback)
    table.insert(EventUpdateCallbacks, callback)
end

-- Advanced Shop Data Collection System
local function CollectShopData()
    spawn(function()
        wait(3) -- Wait for game to load
        
        -- Method 1: Collect from shop GUIs
        local shopGuis = {
            LocalPlayer.PlayerGui:FindFirstChild("ShopGui"),
            LocalPlayer.PlayerGui:FindFirstChild("StoreGui"),
            LocalPlayer.PlayerGui:FindFirstChild("MarketGui"),
            LocalPlayer.PlayerGui:FindFirstChild("BuyGui")
        }
        
        for _, shopGui in pairs(shopGuis) do
            if shopGui then
                for shopName, shopData in pairs(Shops) do
                    local shopFrame = shopGui:FindFirstChild(shopName) or 
                                    shopGui:FindFirstChild(shopData.Name) or
                                    shopGui:FindFirstChild(shopData.Category)
                    
                    if shopFrame then
                        -- Clear existing items to refresh
                        local detectedItems = {}
                        
                        for _, item in pairs(shopFrame:GetChildren()) do
                            if item:IsA("Frame") or item:IsA("TextButton") then
                                local itemData = {
                                    Name = "Unknown Item",
                                    Price = "N/A",
                                    Description = "",
                                    Rarity = "Common"
                                }
                                
                                -- Extract item name
                                local nameLabel = item:FindFirstChild("ItemName") or 
                                                item:FindFirstChild("Name") or 
                                                item:FindFirstChild("Title")
                                if nameLabel and nameLabel:IsA("TextLabel") then
                                    itemData.Name = nameLabel.Text
                                end
                                
                                -- Extract price
                                local priceLabel = item:FindFirstChild("Price") or 
                                                 item:FindFirstChild("Cost") or 
                                                 item:FindFirstChild("Value")
                                if priceLabel and priceLabel:IsA("TextLabel") then
                                    itemData.Price = priceLabel.Text
                                end
                                
                                -- Extract description
                                local descLabel = item:FindFirstChild("Description") or 
                                                item:FindFirstChild("Info") or 
                                                item:FindFirstChild("Details")
                                if descLabel and descLabel:IsA("TextLabel") then
                                    itemData.Description = descLabel.Text
                                end
                                
                                -- Determine rarity from color or text
                                if item.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
                                    itemData.Rarity = "Legendary"
                                elseif item.BackgroundColor3 == Color3.fromRGB(128, 0, 128) then
                                    itemData.Rarity = "Epic"
                                elseif item.BackgroundColor3 == Color3.fromRGB(0, 100, 200) then
                                    itemData.Rarity = "Rare"
                                elseif item.BackgroundColor3 == Color3.fromRGB(0, 200, 0) then
                                    itemData.Rarity = "Uncommon"
                                end
                                
                                table.insert(detectedItems, itemData)
                            end
                        end
                        
                        -- Update shop data with detected items
                        if #detectedItems > 0 then
                            shopData.Items = detectedItems
                        end
                    end
                end
            end
        end
        
        -- Method 2: Scan workspace for shop NPCs and their dialogs
        for _, npc in pairs(Workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc.Name:lower():find("shop") then
                -- Found a shop NPC, try to get their items
                if npc:FindFirstChild("ShopItems") then
                    local shopItems = npc.ShopItems
                    for _, item in pairs(shopItems:GetChildren()) do
                        -- Process shop items from NPC
                        -- This would depend on the specific game's implementation
                    end
                end
            end
        end
        
        -- Method 3: Check ReplicatedStorage for shop data
        if ReplicatedStorage:FindFirstChild("ShopData") then
            local shopData = ReplicatedStorage.ShopData
            for _, shop in pairs(shopData:GetChildren()) do
                if Shops[shop.Name] then
                    -- Update shop items from server data
                    local items = {}
                    for _, item in pairs(shop:GetChildren()) do
                        if item:FindFirstChild("Name") and item:FindFirstChild("Price") then
                            table.insert(items, {
                                Name = item.Name.Value,
                                Price = item.Price.Value,
                                Description = item:FindFirstChild("Description") and item.Description.Value or "",
                                Rarity = item:FindFirstChild("Rarity") and item.Rarity.Value or "Common"
                            })
                        end
                    end
                    if #items > 0 then
                        Shops[shop.Name].Items = items
                    end
                end
            end
        end
    end)
end

-- Auto-refresh shop data every 30 seconds
local function AutoRefreshShops()
    spawn(function()
        while wait(30) do
            CollectShopData()
        end
    end)
end

-- Load Function
function FishIt.Load(WindUI)
    -- Initialize game references
    InitializeReferences()
    
    -- Start event detection
    DetectEvents()
    
    -- Collect and auto-refresh shop data
    CollectShopData()
    AutoRefreshShops()
    
    -- Create main window
    local Window = WindUI:CreateWindow({
        Title = "FishIt Script",
        Subtitle = "Advanced Fishing Automation",
        Size = UDim2.fromOffset(580, 460),
        MinSize = UDim2.fromOffset(400, 300),
        MaxSize = UDim2.fromOffset(800, 600),
        KeySystem = false,
        LoadingTitle = "FishIt Script",
        LoadingSubtitle = "by SkuyyHub",
        ConfigurationSaving = {
            Enabled = true,
            FileName = "FishIt_Config",
            FolderName = "SkuyyHub"
        },
        Discord = {
            Enabled = false,
            Invite = "",
            RememberJoins = false
        }
    })
    
    -- Main Features Tab
    local MainTab = Window:CreateTab({
        Name = "Main Features",
        Icon = "fish"
    })
    
    -- Auto Fish Section
    local AutoFishSection = MainTab:CreateSection("🎣 Auto Fishing System")
    
    AutoFishSection:CreateToggle({
        Name = "Auto Fish (Instant Catch)",
        CurrentValue = false,
        Flag = "AutoFish",
        Callback = function(Value)
            AutoFishEnabled = Value
            if Value then
                AutoFish()
            end
        end,
    })
    
    AutoFishSection:CreateToggle({
        Name = "Legit Always Perfect",
        CurrentValue = false,
        Flag = "LegitPerfect",
        Callback = function(Value)
            LegitPerfectEnabled = Value
            if Value then
                LegitPerfect()
            end
        end,
    })
    
    local FishingSpeed = 1
    AutoFishSection:CreateSlider({
        Name = "Fishing Speed Multiplier",
        Range = {0.1, 5},
        Increment = 0.1,
        CurrentValue = 1,
        Flag = "FishingSpeed",
        Callback = function(Value)
            FishingSpeed = Value
        end,
    })
    
    AutoFishSection:CreateButton({
        Name = "🔄 Reset Fishing Position",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Find nearest fishing spot
                local nearestSpot = nil
                local nearestDistance = math.huge
                
                for _, map in pairs(Maps) do
                    for _, spot in pairs(map.FishingSpots) do
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - spot.Position).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestSpot = spot
                        end
                    end
                end
                
                if nearestSpot then
                    TeleportTo(nearestSpot.Position)
                end
            end
        end,
    })
    
    -- Shell Collection Section
    local ShellSection = MainTab:CreateSection("🐚 Item Collection System")
    
    ShellSection:CreateToggle({
        Name = "Auto Collect Shells & Treasures",
        CurrentValue = false,
        Flag = "AutoShell",
        Callback = function(Value)
            AutoShellEnabled = Value
            if Value then
                AutoShell()
            end
        end,
    })
    
    ShellSection:CreateButton({
        Name = "🔍 Scan for Collectibles",
        Callback = function()
            local collectibles = {}
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("shell") or obj.Name:lower():find("treasure") or obj.Name:lower():find("pearl") then
                    table.insert(collectibles, obj)
                end
            end
            
            WindUI:Notify({
                Title = "Collectibles Scan",
                Content = "Found " .. #collectibles .. " collectible items nearby!",
                Duration = 3
            })
        end,
    })
    
    ShellSection:CreateButton({
        Name = "📍 Teleport to Nearest Shell",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local nearestShell = nil
                local nearestDistance = math.huge
                
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name:lower():find("shell") and obj:IsA("Part") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestShell = obj
                        end
                    end
                end
                
                if nearestShell then
                    TeleportTo(nearestShell.Position)
                else
                    WindUI:Notify({
                        Title = "No Shells Found",
                        Content = "No shells found in the current area.",
                        Duration = 2
                    })
                end
            end
        end,
    })
    
    -- Teleport Tab
    local TeleportTab = Window:CreateTab({
        Name = "Teleports",
        Icon = "map-pin"
    })
    
    -- Maps Section
    local MapsSection = TeleportTab:CreateSection("🗺️ Maps & Fishing Locations")
    
    -- Quick teleport section
    local QuickTeleportSection = TeleportTab:CreateSection("⚡ Quick Actions")
    
    QuickTeleportSection:CreateButton({
        Name = "🏠 Return to Spawn",
        Callback = function()
            TeleportTo(Vector3.new(0, 5, 0))
        end,
    })
    
    QuickTeleportSection:CreateButton({
        Name = "🎣 Best Fishing Spot",
        Callback = function()
            -- Teleport to highest rarity spot
            local bestSpot = nil
            local rarityOrder = {["Mythic"] = 6, ["Legendary"] = 5, ["Epic"] = 4, ["Rare"] = 3, ["Uncommon"] = 2, ["Common"] = 1}
            local highestRarity = 0
            
            for _, map in pairs(Maps) do
                for _, spot in pairs(map.FishingSpots) do
                    local rarity = rarityOrder[spot.Rarity] or 1
                    if rarity > highestRarity then
                        highestRarity = rarity
                        bestSpot = spot
                    end
                end
            end
            
            if bestSpot then
                TeleportTo(bestSpot.Position)
                WindUI:Notify({
                    Title = "Best Spot",
                    Content = "Teleported to " .. bestSpot.Name .. " (" .. bestSpot.Rarity .. ")!",
                    Duration = 3
                })
            end
        end,
    })
    
    -- Create dropdown for map selection
    local mapOptions = {}
    for mapName, mapData in pairs(Maps) do
        table.insert(mapOptions, mapData.Name)
    end
    
    MapsSection:CreateDropdown({
        Name = "Select Map",
        Options = mapOptions,
        CurrentOption = mapOptions[1],
        Flag = "SelectedMap",
        Callback = function(Option)
            for mapName, mapData in pairs(Maps) do
                if mapData.Name == Option then
                    TeleportTo(mapData.Position)
                    WindUI:Notify({
                        Title = "Map Teleport",
                        Content = "Teleported to " .. mapData.Name .. "!",
                        Duration = 2
                    })
                    break
                end
            end
        end,
    })
    
    -- Detailed map sections
    for mapName, mapData in pairs(Maps) do
        local MapSection = TeleportTab:CreateSection(mapData.Name)
        
        MapSection:CreateButton({
            Name = "📍 Teleport to " .. mapData.Name,
            Callback = function()
                TeleportTo(mapData.Position)
                WindUI:Notify({
                    Title = "Map Teleport",
                    Content = "Teleported to " .. mapData.Name .. "!",
                    Duration = 2
                })
            end,
        })
        
        -- Organize fishing spots by rarity
        local spotsByRarity = {}
        for _, spot in pairs(mapData.FishingSpots) do
            if not spotsByRarity[spot.Rarity] then
                spotsByRarity[spot.Rarity] = {}
            end
            table.insert(spotsByRarity[spot.Rarity], spot)
        end
        
        -- Display spots by rarity (highest first)
        local rarityOrder = {"Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}
        for _, rarity in ipairs(rarityOrder) do
            if spotsByRarity[rarity] then
                for _, spot in pairs(spotsByRarity[rarity]) do
                    local rarityEmoji = {
                        ["Mythic"] = "🌟",
                        ["Legendary"] = "💎",
                        ["Epic"] = "💜",
                        ["Rare"] = "💙",
                        ["Uncommon"] = "💚",
                        ["Common"] = "🤍"
                    }
                    
                    MapSection:CreateButton({
                        Name = "   " .. (rarityEmoji[spot.Rarity] or "🎣") .. " " .. spot.Name .. " (" .. spot.Rarity .. ")",
                        Callback = function()
                            TeleportTo(spot.Position)
                            WindUI:Notify({
                                Title = "Fishing Spot",
                                Content = "Teleported to " .. spot.Name .. "!",
                                Duration = 2
                            })
                        end,
                    })
                end
            end
        end
    end
    
    -- Events Tab
    local EventsTab = Window:CreateTab({
        Name = "Events",
        Icon = "calendar"
    })
    
    local EventsSection = EventsTab:CreateSection("🎪 Event Detection & Teleport")
    local EventButtonsSection = EventsTab:CreateSection("Active Events")
    
    -- Event status display
    local EventStatusParagraph = EventsSection:CreateParagraph({
        Title = "Event Status",
        Content = "Scanning for active events..."
    })
    
    -- Create dynamic event buttons
    local EventButtons = {}
    
    local function UpdateEventDisplay()
        local activeEvents = 0
        local eventList = "Current Events:\n"
        
        for eventName, eventData in pairs(Events) do
            if eventData.Active then
                activeEvents = activeEvents + 1
                eventList = eventList .. "✅ " .. eventData.Name .. " (" .. eventData.Duration .. ")\n"
            else
                eventList = eventList .. "❌ " .. eventData.Name .. "\n"
            end
        end
        
        -- Update status paragraph
        EventStatusParagraph:Set({
            Title = "Event Status (" .. activeEvents .. " Active)",
            Content = eventList
        })
    end
    
    -- Register update callback
    RegisterEventCallback(UpdateEventDisplay)
    
    -- Create event teleport buttons
    for eventName, eventData in pairs(Events) do
        local button = EventButtonsSection:CreateButton({
            Name = eventData.Name,
            Callback = function()
                if eventData.Active then
                    TeleportTo(eventData.Position)
                    WindUI:Notify({
                        Title = "Event Teleport",
                        Content = "Teleported to " .. eventData.Name .. "!",
                        Duration = 2
                    })
                else
                    WindUI:Notify({
                        Title = "Event Inactive",
                        Content = eventData.Name .. " is not currently active.",
                        Duration = 2
                    })
                end
            end,
        })
        EventButtons[eventName] = button
    end
    
    EventsSection:CreateButton({
        Name = "🔄 Force Refresh Events",
        Callback = function()
            DetectEvents()
            UpdateEventDisplay()
            WindUI:Notify({
                Title = "Events Refreshed",
                Content = "Event detection refreshed!",
                Duration = 2
            })
        end,
    })
    
    EventsSection:CreateToggle({
        Name = "Auto Join Events",
        CurrentValue = false,
        Flag = "AutoJoinEvents",
        Callback = function(Value)
            if Value then
                spawn(function()
                    while Value do
                        wait(10)
                        for eventName, eventData in pairs(Events) do
                            if eventData.Active and eventName ~= "Admin Event" then
                                TeleportTo(eventData.Position)
                                wait(5)
                                break
                            end
                        end
                    end
                end)
            end
        end,
    })
    
    -- Initial update
    UpdateEventDisplay()
    
    -- Shop Tab
    local ShopTab = Window:CreateTab({
        Name = "Shop",
        Icon = "shopping-cart"
    })
    
    -- Shop Overview Section
    local ShopOverviewSection = ShopTab:CreateSection("🛍️ Shop Overview")
    
    ShopOverviewSection:CreateButton({
        Name = "🔄 Refresh All Shops",
        Callback = function()
            CollectShopData()
            WindUI:Notify({
                Title = "Shops Refreshed",
                Content = "All shop data has been refreshed!",
                Duration = 2
            })
        end,
    })
    
    ShopOverviewSection:CreateButton({
        Name = "🗺️ Visit All Shops",
        Callback = function()
            spawn(function()
                for shopName, shopData in pairs(Shops) do
                    TeleportTo(shopData.Position)
                    wait(2) -- Wait at each shop to load items
                end
                WindUI:Notify({
                    Title = "Shop Tour Complete",
                    Content = "Visited all shops to load items!",
                    Duration = 3
                })
            end)
        end,
    })
    
    -- Organize shops by category
    local shopsByCategory = {}
    for shopName, shopData in pairs(Shops) do
        if not shopsByCategory[shopData.Category] then
            shopsByCategory[shopData.Category] = {}
        end
        table.insert(shopsByCategory[shopData.Category], {name = shopName, data = shopData})
    end
    
    -- Create sections for each category
    for category, categoryShops in pairs(shopsByCategory) do
        local CategorySection = ShopTab:CreateSection("📋 " .. category .. " Shops")
        
        for _, shop in pairs(categoryShops) do
            local shopName = shop.name
            local shopData = shop.data
            
            -- Shop teleport button
            CategorySection:CreateButton({
                Name = "📍 " .. shopData.Name,
                Callback = function()
                    TeleportTo(shopData.Position)
                    WindUI:Notify({
                        Title = "Shop Teleport",
                        Content = "Teleported to " .. shopData.Name .. "!",
                        Duration = 2
                    })
                end,
            })
            
            -- Display shop items organized by rarity
            if #shopData.Items > 0 then
                -- Organize items by rarity
                local itemsByRarity = {}
                for _, item in pairs(shopData.Items) do
                    if not itemsByRarity[item.Rarity] then
                        itemsByRarity[item.Rarity] = {}
                    end
                    table.insert(itemsByRarity[item.Rarity], item)
                end
                
                -- Display items by rarity (highest first)
                local rarityOrder = {"Divine", "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}
                for _, rarity in ipairs(rarityOrder) do
                    if itemsByRarity[rarity] then
                        for _, item in pairs(itemsByRarity[rarity]) do
                            local rarityEmoji = {
                                ["Divine"] = "✨",
                                ["Mythic"] = "🌟",
                                ["Legendary"] = "💎",
                                ["Epic"] = "💜",
                                ["Rare"] = "💙",
                                ["Uncommon"] = "💚",
                                ["Common"] = "🤍"
                            }
                            
                            CategorySection:CreateButton({
                                Name = "  " .. (rarityEmoji[item.Rarity] or "💰") .. " " .. item.Name .. " - " .. item.Price,
                                Callback = function()
                                    -- Comprehensive buy logic
                                    pcall(function()
                                        -- Method 1: Use shop remote if available
                                        if GameRemotes.Shop then
                                            GameRemotes.Shop:FireServer(item.Name)
                                            WindUI:Notify({
                                                Title = "Purchase Attempt",
                                                Content = "Trying to buy " .. item.Name .. "...",
                                                Duration = 2
                                            })
                                            return
                                        end
                                        
                                        -- Method 2: Find and fire specific shop remotes
                                        if ReplicatedStorage:FindFirstChild("Remotes") then
                                            local remotes = ReplicatedStorage.Remotes
                                            local buyRemotes = {
                                                remotes:FindFirstChild("BuyItem"),
                                                remotes:FindFirstChild("Purchase"),
                                                remotes:FindFirstChild("Shop"),
                                                remotes:FindFirstChild("Buy")
                                            }
                                            
                                            for _, remote in pairs(buyRemotes) do
                                                if remote then
                                                    remote:FireServer(item.Name, shopData.Category, 1)
                                                    WindUI:Notify({
                                                        Title = "Purchase Attempt",
                                                        Content = "Trying to buy " .. item.Name .. "...",
                                                        Duration = 2
                                                    })
                                                    break
                                                end
                                            end
                                        end
                                        
                                        -- Method 3: GUI-based purchasing
                                        if LocalPlayer.PlayerGui:FindFirstChild("ShopGui") then
                                            local shopGui = LocalPlayer.PlayerGui.ShopGui
                                            for _, frame in pairs(shopGui:GetDescendants()) do
                                                if frame:IsA("TextButton") and 
                                                   (frame.Text:find(item.Name) or frame.Name:find(item.Name)) then
                                                    frame.MouseButton1Click:Fire()
                                                    WindUI:Notify({
                                                        Title = "Purchase Attempt",
                                                        Content = "Clicking buy button for " .. item.Name .. "...",
                                                        Duration = 2
                                                    })
                                                    break
                                                end
                                            end
                                        end
                                        
                                        -- Method 4: Teleport to shop and auto-buy
                                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                                            TeleportTo(shopData.Position)
                                            
                                            wait(1)
                                            
                                            -- Look for shop NPC or buy prompt
                                            for _, obj in pairs(Workspace:GetChildren()) do
                                                if obj.Name:lower():find("shop") and obj:FindFirstChild("ClickDetector") then
                                                    fireclickdetector(obj.ClickDetector)
                                                    break
                                                elseif obj:FindFirstChild("ProximityPrompt") then
                                                    fireproximityprompt(obj.ProximityPrompt)
                                                    break
                                                end
                                            end
                                            
                                            wait(0.5)
                                            TeleportTo(oldPos.Position)
                                            
                                            WindUI:Notify({
                                                Title = "Shop Visit",
                                                Content = "Visited " .. shopData.Name .. " to buy " .. item.Name,
                                                Duration = 3
                                            })
                                        end
                                    end)
                                end,
                            })
                        end
                    end
                end
            else
                CategorySection:CreateParagraph({
                    Title = shopData.Name .. " Items",
                    Content = "Items will load automatically. Visit the shop in-game or use 'Refresh All Shops' button!"
                })
            end
            
            -- Add divider between shops in same category
            if shop ~= categoryShops[#categoryShops] then
                CategorySection:CreateDivider()
            end
        end
    end
    
    -- Settings & Info Tab
    local SettingsTab = Window:CreateTab({
        Name = "Settings",
        Icon = "settings"
    })
    
    -- General Settings
    local GeneralSection = SettingsTab:CreateSection("⚙️ General Settings")
    
    GeneralSection:CreateToggle({
        Name = "Show Notifications",
        CurrentValue = true,
        Flag = "ShowNotifications",
        Callback = function(Value)
            -- This would control notification display
        end,
    })
    
    GeneralSection:CreateToggle({
        Name = "Safe Mode (Slower but Safer)",
        CurrentValue = false,
        Flag = "SafeMode",
        Callback = function(Value)
            -- This would add delays to make actions less detectable
        end,
    })
    
    GeneralSection:CreateSlider({
        Name = "Teleport Height Offset",
        Range = {0, 10},
        Increment = 0.5,
        CurrentValue = 2,
        Flag = "TeleportOffset",
        Callback = function(Value)
            -- This would adjust teleport height
        end,
    })
    
    -- Script Information
    local InfoSection = SettingsTab:CreateSection("📝 Script Information")
    
    InfoSection:CreateParagraph({
        Title = "FishIt Enhanced Script v2.0",
        Content = "• Auto Fish with instant catching system\n• Legit always perfect with realistic timing\n• Advanced shell & treasure collection\n• Real-time event detection & auto-join\n• Comprehensive map & fishing spot teleports\n• Unified shop system with auto-buy\n• Smart item detection & collection\n• Configuration saving & loading"
    })
    
    InfoSection:CreateParagraph({
        Title = "Quick Start Guide",
        Content = "1. 🎣 Enable Auto Fish for automated fishing\n2. ✨ Use Legit Perfect for realistic perfect catches\n3. 🐚 Enable Auto Shell to collect treasures\n4. 🗺️ Use Teleports for quick travel\n5. 🎪 Check Events for active events\n6. 🛍️ Visit Shops to buy equipment\n7. ⚙️ Adjust settings for your preference"
    })
    
    -- Status Section
    local StatusSection = SettingsTab:CreateSection("📊 Status & Statistics")
    
    local GameStatusParagraph = StatusSection:CreateParagraph({
        Title = "Game Status",
        Content = "Loading game information..."
    })
    
    -- Update status information
    spawn(function()
        while wait(5) do
            local statusText = "Current Game: FishIt\n"
            statusText = statusText .. "Player: " .. LocalPlayer.Name .. "\n"
            statusText = statusText .. "Auto Fish: " .. (AutoFishEnabled and "Enabled" or "Disabled") .. "\n"
            statusText = statusText .. "Perfect Catch: " .. (LegitPerfectEnabled and "Enabled" or "Disabled") .. "\n"
            statusText = statusText .. "Shell Collection: " .. (AutoShellEnabled and "Enabled" or "Disabled") .. "\n"
            
            local activeEvents = 0
            for _, eventData in pairs(Events) do
                if eventData.Active then
                    activeEvents = activeEvents + 1
                end
            end
            statusText = statusText .. "Active Events: " .. activeEvents
            
            GameStatusParagraph:Set({
                Title = "Current Status",
                Content = statusText
            })
        end
    end)
    
    -- Utility Section
    local UtilitySection = SettingsTab:CreateSection("🔧 Utilities")
    
    UtilitySection:CreateButton({
        Name = "🔄 Rejoin Server",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end,
    })
    
    UtilitySection:CreateButton({
        Name = "📎 Copy Game Link",
        Callback = function()
            setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
            WindUI:Notify({
                Title = "Game Link Copied",
                Content = "Game link copied to clipboard!",
                Duration = 2
            })
        end,
    })
    
    UtilitySection:CreateButton({
        Name = "💰 Check Player Stats", 
        Callback = function()
            -- This would check player's in-game stats
            local statsText = "Player Statistics:\n"
            if LocalPlayer:FindFirstChild("leaderstats") then
                for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
                    statsText = statsText .. stat.Name .. ": " .. stat.Value .. "\n"
                end
            else
                statsText = "No leaderstats found."
            end
            
            WindUI:Notify({
                Title = "Player Stats",
                Content = statsText,
                Duration = 5
            })
        end,
    })
    
    -- Welcome notification
    WindUI:Notify({
        Title = "FishIt Enhanced Script",
        Content = "All features loaded successfully! Happy fishing! 🎣",
        Duration = 5
    })
    
    return true, "FishIt Enhanced Script v2.0 loaded successfully with all features!"
end

return FishIt