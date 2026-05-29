local Players = game:GetService("Players")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Hub",
   LoadingTitle = "Universal Hub",
   LoadingSubtitle = "",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UniversalHub",
      FileName = "UniversalConfig"
   }
})

-- ==================== UNIVERSAL TAB ====================
local UniversalTab = Window:CreateTab("Universal", 4483362458)

UniversalTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end,
})

UniversalTab:CreateInput({
    Name = "Enter WalkSpeed",
    PlaceholderText = "Type number...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if num and hum then hum.WalkSpeed = num end
    end,
})

UniversalTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = Value end
    end,
})

UniversalTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().InfiniteJump = Value
    end,
})

UniversalTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().Fly = Value
    end,
})

UniversalTab:CreateButton({
    Name = "God Mode",
    Callback = function()
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = 9e9
            hum.Health = 9e9
        end
    end,
})

UniversalTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

-- ==================== MM2 TAB (Only in MM2) ====================
if game.PlaceId == 142823291 then

    local MM2Tab = Window:CreateTab("MM2", 4483362458)

    -- Role ESP System
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "MM2ESP"
    ESPFolder.Parent = game.CoreGui

    local function CreateESP(plr)
        if plr == game.Players.LocalPlayer then return end

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = plr.Name
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 250, 0, 60)
        Billboard.Enabled = false
        Billboard.Parent = ESPFolder

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1,0,1,0)
        Label.BackgroundTransparency = 1
        Label.TextScaled = true
        Label.Font = Enum.Font.GothamBold
        Label.TextStrokeTransparency = 0
        Label.Text = plr.Name
        Label.Parent = Billboard

        task.spawn(function()
            while Billboard.Parent do
                pcall(function()
                    local char = plr.Character
                    if char and char:FindFirstChild("Head") then
                        Billboard.Adornee = char.Head
                    end

                    local hasKnife = char and (char:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife"))
                    local hasGun = char and (char:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun"))

                    if hasKnife then
                        Label.TextColor3 = Color3.fromRGB(255, 0, 0)
                        Label.Text = plr.Name .. " [MURDERER]"
                    elseif hasGun then
                        Label.TextColor3 = Color3.fromRGB(0, 100, 255)
                        Label.Text = plr.Name .. " [SHERIFF]"
                    else
                        Label.TextColor3 = Color3.fromRGB(0, 255, 100)
                        Label.Text = plr.Name .. " [INNOCENT]"
                    end
                end)
                task.wait(0.4)
            end
        end)
    end

    for _, plr in pairs(Players:GetPlayers()) do
        CreateESP(plr)
    end
    Players.PlayerAdded:Connect(CreateESP)

    MM2Tab:CreateToggle({
        Name = "Role ESP",
        CurrentValue = false,
        Callback = function(state)
            for _, gui in pairs(ESPFolder:GetChildren()) do
                if gui:IsA("BillboardGui") then gui.Enabled = state end
            end
        end,
    })

    -- More MM2 Features
    MM2Tab:CreateButton({
        Name = "Auto Grab Gun",
        Callback = function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "GunDrop" or v.Name == "Gun" then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end,
    })

    MM2Tab:CreateButton({
        Name = "Chat Expose Roles",
        Callback = function()
            for _, plr in pairs(game.Players:GetPlayers()) do
                local bp = plr:FindFirstChild("Backpack")
                if bp then
                    if bp:FindFirstChild("Knife") then
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(plr.Name .. " HAS THE KNIFE!", "normalchat")
                    end
                    if bp:FindFirstChild("Gun") then
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(plr.Name .. " HAS THE GUN!", "normalchat")
                    end
                end
            end
        end,
    })

    MM2Tab:CreateButton({
        Name = "Fling Murderer",
        Callback = function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local hasKnife = false
                    for _, tool in pairs(plr.Character:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:find("Knife") then hasKnife = true end
                    end
                    if hasKnife then
                        local root = game.Players.LocalPlayer.Character.HumanoidRootPart
                        root.Velocity = (plr.Character.HumanoidRootPart.Position - root.Position).Unit * 350
                    end
                end
            end
        end,
    })

    MM2Tab:CreateButton({
        Name = "Fling Sheriff",
        Callback = function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local hasGun = false
                    for _, tool in pairs(plr.Character:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:find("Gun") or tool.Name:find("Sheriff")) then hasGun = true end
                    end
                    if hasGun then
                        local root = game.Players.LocalPlayer.Character.HumanoidRootPart
                        root.Velocity = (plr.Character.HumanoidRootPart.Position - root.Position).Unit * 350
                    end
                end
            end
        end,
    })

    MM2Tab:CreateToggle({
        Name = "Kill Aura",
        CurrentValue = false,
        Callback = function(state)
            getgenv().KillAura = state
        end,
    })

    MM2Tab:CreateSlider({
        Name = "Hitbox Expander",
        Range = {2, 30},
        Increment = 1,
        CurrentValue = 5,
        Callback = function(Value)
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.Size = Vector3.new(Value, Value, Value)
                end
            end
        end,
    })

end

-- ==================== GLOBAL LOGIC ====================
game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJump then
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().Fly then
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local move = Vector3.zero
            local cam = workspace.CurrentCamera
            local uis = game:GetService("UserInputService")
            if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
            root.AssemblyLinearVelocity = move.Unit * 60
        end
    end

    -- Kill Aura
    if getgenv().KillAura then
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist < 15 then
                        root.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
    Title = "Universal Hub",
    Content = "Loaded Successfully! MM2 Tab Added",
    Duration = 6,
    Image = 4483362458,
})
