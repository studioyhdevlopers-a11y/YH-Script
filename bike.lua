local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "YH Studio | Bike for Egg [Pro]",
   LoadingTitle = "Loading YH Script...",
   LoadingSubtitle = "by YH Dev",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local MainTab = Window:CreateTab("🏠 Main Farm", 4483362458)
local ZonesTab = Window:CreateTab("🗺️ Map Zones", 4483362458)
local MiscTab = Window:CreateTab("⚡ Extras", 4483362458)

local selectedZone = "Forest"
local autoFarmToggle = false
local savedPart = nil

local zonesList = {
   "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic"
}

MainTab:CreateDropdown({
   Name = "Select Zone for Auto Steal Egg",
   Options = zonesList,
   CurrentOption = "Forest",
   Flag = "SelectedEggZone",
   Callback = function(Option)
      selectedZone = Option
   end,
})

local function getBestRemote()
   for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
      if v:IsA("RemoteEvent") then
         local name = v.Name:lower()
         if name:find("egg") or name:find("steal") or name:find("collect") or name:find("claim") or name:find("bike") then
            return v
         end
      end
   end
   return nil
end

MainTab:CreateToggle({
   Name = "Auto Steal Egg (Pro Bypass & Lobby Return)",
   CurrentValue = false,
   Flag = "AutoEgg",
   Callback = function(Value)
      autoFarmToggle = Value
      if autoFarmToggle then
         task.spawn(function()
            local player = game.Players.LocalPlayer
            while autoFarmToggle do
               local char = player.Character
               if char and char:FindFirstChild("HumanoidRootPart") then
                  local hrp = char.HumanoidRootPart
                  local lobbyPos = hrp.CFrame
                  
                  for _, obj in pairs(workspace:GetDescendants()) do
                     if obj.Name:lower() == "lobby" and (obj:IsA("BasePart") or obj:IsA("Model")) then
                        local p = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                        if p and p:IsA("BasePart") then
                           lobbyPos = p.CFrame + Vector3.new(0, 3, 0)
                           break
                        end
                     end
                  end
                  
                  local targetFound = false
                  for _, prompt in pairs(workspace:GetDescendants()) do
                     if not autoFarmToggle then break end
                     if prompt:IsA("ProximityPrompt") then
                        local parentObj = prompt.Parent
                        if parentObj then
                           local nameLower = parentObj.Name:lower()
                           local parentModel = parentObj.Parent and parentObj.Parent.Name:lower() or ""
                           if (nameLower:find("egg") or parentModel:find("egg")) and (nameLower:find(selectedZone:lower()) or parentModel:find(selectedZone:lower())) then
                              local targetPart = nil
                              if parentObj:IsA("BasePart") then
                                 targetPart = parentObj
                              elseif parentObj:IsA("Model") and parentObj.PrimaryPart then
                                 targetPart = parentObj.PrimaryPart
                              elseif parentObj:IsA("Model") then
                                 targetPart = parentObj:FindFirstChildWhichIsA("BasePart")
                              end
                              
                              if targetPart then
                                 hrp.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                                 targetFound = true
                                 task.wait(0.15)
                                 
                                 pcall(function() fireproximityprompt(prompt, 0) end)
                                 local remote = getBestRemote()
                                 if remote then
                                    pcall(function() remote:FireServer(selectedZone) end)
                                 end
                                 break
                              end
                           end
                        end
                     end
                  end
                  
                  task.wait(0.3)
                  hrp.CFrame = lobbyPos
               end
               task.wait(1)
            end
         end)
      end
   end,
})

ZonesTab:CreateSection("Saved Position System")

ZonesTab:CreateButton({
   Name = "Sit 1 (Save Current Position & Create Neon Red Part)",
   Callback = function()
      local player = game.Players.LocalPlayer
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         local hrp = char.HumanoidRootPart
         if savedPart then savedPart:Destroy() end
         savedPart = Instance.new("Part")
         savedPart.Name = "YH_SavedPosition"
         savedPart.Size = Vector3.new(4, 1, 4)
         savedPart.Position = hrp.Position - Vector3.new(0, 3, 0)
         savedPart.Anchored = true
         savedPart.CanCollide = true
         savedPart.Material = Enum.Material.Neon
         savedPart.BrickColor = BrickColor.new("Bright red")
         savedPart.Parent = workspace
      end
   end,
})

ZonesTab:CreateButton({
   Name = "Teleport to Saved Position (Sit 1)",
   Callback = function()
      local player = game.Players.LocalPlayer
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") and savedPart then
         char.HumanoidRootPart.CFrame = savedPart.CFrame + Vector3.new(0, 4, 0)
      end
   end,
})

ZonesTab:CreateSection("Map Zones Teleport")

for _, zoneName in ipairs(zonesList) do
   ZonesTab:CreateButton({
      Name = "Teleport to: " .. zoneName,
      Callback = function()
         local player = game.Players.LocalPlayer
         local char = player.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(workspace:GetDescendants()) do
               if v.Name:lower():find(zoneName:lower()) and (v:IsA("BasePart") or v:IsA("Model")) then
                  local val = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                  if val and val:IsA("BasePart") then
                     char.HumanoidRootPart.CFrame = val.CFrame + Vector3.new(0, 5, 0)
                     break
                  end
               end
            end
         end
      end,
   })
end

MiscTab:CreateSlider({
   Name = "WalkSpeed Booster",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local char = player.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

MiscTab:CreateButton({
   Name = "Toggle Noclip",
   Callback = function()
      game:GetService("RunService").Stepped:Connect(function()
         local char = game.Players.LocalPlayer and game.Players.LocalPlayer.Character
         if char then
            for _, part in pairs(char:GetDescendants()) do
               if part:IsA("BasePart") and part.CanCollide then
                  part.CanCollide = false
               end
            end
         end
      end)
   end,
})
