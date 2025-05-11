-- Auto Farm Script for Blox Fruits (Delta Executor)
-- Created by Grok for xAI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage.Remotes.CommF_
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Data = LocalPlayer.Data
local Enemies = Workspace:WaitForChild("Enemies", 10)
local NPCs = Workspace:WaitForChild("NPCs", 10)
local Backpack = LocalPlayer.Backpack
local Character = LocalPlayer.Character

-- Configuration
local Configs = {
    Farming = {
        Weapon = "Combat", -- Default weapon
        Level = {
            AutoFarm = true, -- Enable auto farm
            TP_Speed = 2, -- Teleport speed
        },
        AutoFarmSettings = {
            PosX = 0,
            PosY = 19,
            PosZ = -10,
            Hitbox = false,
        }
    },
    System = {
        BREAKALLTHISSHITHAHAHAHAHA = false -- Emergency stop flag
    }
}

-- World Check
local placeId = game.PlaceId
local WorldCheck = {
    ["First Sea"] = placeId == 2753915549,
    ["Second Sea"] = placeId == 4442272183,
    ["Third Sea"] = placeId == 7449423635
}

-- Mob Lists per Sea
local MobList = {}
if WorldCheck["First Sea"] then
    MobList = {
        "Bandit", "Monkey", "Gorilla", "Pirate", "Brute", "Desert Bandit", "Desert Officer",
        "Snow Bandit", "Snowman", "Chief Petty Officer", "Sky Bandit", "Dark Master",
        "Toga Warrior", "Gladiator", "Military Soldier", "Military Spy", "Fishman Warrior",
        "Fishman Commando", "God's Guard", "Shanda", "Royal Squad", "Royal Soldier",
        "Galley Pirate", "Galley Captain"
    }
elseif WorldCheck["Second Sea"] then
    MobList = {
        "Raider", "Mercenary", "Sw hospitalan Pirate", "Factory Staff", "Marine Lieutenant",
        "Marine Captain", "Zombie", "Vampire", "Snow Trooper", "Winter Warrior",
        "Lab Subordinate", "Horned Warrior", "Magma Ninja", "Lava Pirate",
        "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer",
        "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter"
    }
elseif WorldCheck["Third Sea"] then
    MobList = {
        "Pirate Millionaire", "Dragon Crew Warrior", "Dragon Crew Archer", "Female Islander",
        "Giant Islander", "Marine Commodore", "Marine Rear Admiral", "Fishman Raider",
        "Fishman Captain", "Forest Pirate", "Mythological Pirate", "Jungle Pirate",
        "Musketeer Pirate", "Reborn Skeleton", "Living Zombie", "Demonic Soul",
        "Posessed Mummy", "Peanut Scout", "Peanut President", "Ice Cream Chef",
        "Ice Cream Commander", "Cookie Crafter", "Cake Guard", "Baking Staff",
        "Head Baker", "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief",
        "Candy Rebel", "Candy Pirate", "Snow Demon", "Isle Outlaw", "Island Boy",
        "Sun-kissed Warrior", "Isle Champion"
    }
end --

-- Utility Functions
local function Tp(cframe, speed)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = Character.HumanoidRootPart
    local startPos = hrp.Position
    local targetPos = cframe.Position
    local direction = (targetPos - startPos).Unit
    local distance = (targetPos - startPos).Magnitude
    local steps = math.floor(distance / speed)

    for i = 1, steps do
        if Configs.System.BREAKALLTHISSHITHAHAHAHAHA then break end
        if LocalPlayer:DistanceFromCharacter(targetPos) <= 50 then
            hrp.CFrame = cframe
            break
        end
        startPos = startPos + direction * speed
        hrp.CFrame = CFrame.new(startPos)
        task.wait()
    end
end

local function EquipWeapon(name)
    if Backpack:FindFirstChild(name) then
        local tool = Backpack:FindFirstChild(name)
        task.wait(0.02)
        Character.Humanoid:EquipTool(tool)
        task.wait(0.5)
    end
end

local function SetHum(mob)
    if not mob then return end
    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        hrp.CanCollide = false
        humanoid.WalkSpeed = 0
        hrp.CanQuery = false
        if Configs.Farming.AutoFarmSettings.Hitbox then
            hrp.Size = Vector3.new(64, 64, 64)
        end
        if humanoid:FindFirstChild("Animator") then
            humanoid.Animator:Destroy()
        end
    end
end

local function Hit()
    if identifyexecutor() == "Delta" then
        VirtualInputManager:SendMouseButtonEvent(9999, 9999, 0, true, game, 0)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(9999, 9999, 0, false, game, 0)
    end
end

-- Level and Quest Data
local function CheckLevel()
    local Lv = Data.Level.Value
    if WorldCheck["First Sea"] then
        if Lv <= 9 then
            return {
                Mob = "Bandit [Lv. 5]",
                Quest = "BanditQuest1",
                QuestLevel = 1,
                MobName = "Bandit",
                QuestPos = CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875),
                FarmPos = CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953)
            }
        elseif Lv <= 14 then
            return {
                Mob = "Monkey [Lv. 14]",
                Quest = "JungleQuest",
                QuestLevel = 1,
                MobName = "Monkey",
                QuestPos = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102),
                FarmPos = CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
            }
        elseif Lv <= 29 then
            return {
                Mob = "Gorilla [Lv. 20]",
                Quest = "JungleQuest",
                QuestLevel = 2,
                MobName = "Gorilla",
                QuestPos = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102),
                FarmPos = CFrame.new(-1142.6488037109, 40.462348937988, -515.39227294922)
            }
        -- Add more levels as needed
        end
    elseif WorldCheck["Second Sea"] then
        if Lv <= 724 then
            return {
                Mob = "Raider [Lv. 700]",
                Quest = "Area1Quest",
                QuestLevel = 1,
                MobName = "Raider",
                QuestPos = CFrame.new(-429.54351806641, 71.769996643066, 1836.1818847656),
                FarmPos = CFrame.new(-737.02612304688, 39.303985595703, 1859.9951171875)
            }
        -- Add more levels as needed
        end
    elseif WorldCheck["Third Sea"] then
        if Lv <= 1524 then
            return {
                Mob = "Pirate Millionaire [Lv. 1500]",
                Quest = "PiratePortQuest",
                QuestLevel = 1,
                MobName = "Pirate Millionaire",
                QuestPos = CFrame.new(-290.07455444336, 42.903465270996, 5581.58984375),
                FarmPos = CFrame.new(81.164993286133, 43.755737304688, 5724.7021484375)
            }
        -- Add more levels as needed
        end
    end
    return nil
end

-- Main Auto Farm Loop
local function AutoFarm()
    if not Configs.Farming.Level.AutoFarm then return end
    pcall(function()
        local levelData = CheckLevel()
        if not levelData then
            warn("No level data found for current level")
            return
        end

        local questTitle = PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
        if not string.find(questTitle, levelData.MobName) then
            CommF:InvokeServer("AbandonQuest")
        end

        if not PlayerGui.Main.Quest.Visible then
            Tp(levelData.QuestPos, Configs.Farming.Level.TP_Speed)
            if LocalPlayer:DistanceFromCharacter(levelData.QuestPos.Position) <= 3 then
                task.wait(1.2)
                CommF:InvokeServer("StartQuest", levelData.Quest, levelData.QuestLevel)
                task.wait(0.5)
            end
        else
            EquipWeapon(Configs.Farming.Weapon)
            local targetMob = Enemies:FindFirstChild(levelData.MobName)
            if targetMob and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 then
                Tp(targetMob.HumanoidRootPart.CFrame * CFrame.new(
                    Configs.Farming.AutoFarmSettings.PosX,
                    Configs.Farming.AutoFarmSettings.PosY,
                    Configs.Farming.AutoFarmSettings.PosZ
                ), Configs.Farming.Level.TP_Speed)
                SetHum(targetMob)
                Hit()
            else
                local replicatedMob = ReplicatedStorage:FindFirstChild(levelData.MobName)
                if replicatedMob then
                    Tp(replicatedMob:GetPivot() * CFrame.new(0, 35, 0), Configs.Farming.Level.TP_Speed)
                else
                    Tp(levelData.FarmPos * CFrame.new(0, 35, 0), Configs.Farming.Level.TP_Speed)
                end
            end
        end
    end)
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    if Configs.Farming.Level.AutoFarm then
        pcall(function()
            if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                AutoFarm()
            end
        end)
    end
end)

-- Notification
local Notification = loadstring(game:HttpGet('https://raw.githubusercontent.com/3345-c-a-t-s-u-s/neuron/refs/heads/main/script.lua'))().Notification()
Notification.new({
    Description = "Auto Farm script loaded successfully!",
    Title = "Delta Auto Farm",
    Duration = 5
})

warn("[Delta Auto Farm] : Script is running")