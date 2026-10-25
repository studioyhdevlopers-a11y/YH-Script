local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local HubWindow = Rayfield:CreateWindow({
   Name = "YH Studio | Hub",
   LoadingTitle = "YH Studio Hub",
   LoadingSubtitle = "by YH Dev",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = true,
   KeySettings = {
      Title = "YH Studio | Key System",
      Subtitle = "Get your access key",
      Note = "Key changes periodically for security!",
      FileName = "YHStudioKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"YH-Free563719di47dj9r94k"}
   }
})

local HubTab = HubWindow:CreateTab("🏠 Games Hub", 4483362458)
local HubMisc = HubWindow:CreateTab("⚡ Settings", 4483362458)

HubMisc:CreateButton({
   Name = "Copy Current Key to Clipboard",
   Callback = function()
      if setclipboard then
         setclipboard("YH-Free563719di47dj9r94k")
         Rayfield:Notify({
            Title = "Success",
            Content = "Key copied to clipboard!",
            Duration = 3,
         })
      end
   end,
})

HubTab:CreateSection("Available Scripts")

HubTab:CreateButton({
   Name = "Bike for Egg",
   Callback = function()
      HubWindow:Destroy()
      
      local success, result = pcall(function()
         return loadstring(game:HttpGet("https://raw.githubusercontent.com/studioyhdevlopers-a11y/YH-Script/refs/heads/main/bike.lua"))()
      end)
      
      if not success then
         print("Error loading script: " .. tostring(result))
      end
   end,
})

HubTab:CreateLabel("More scripts coming soon...")
