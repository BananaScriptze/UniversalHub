local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().InfiniteJump = false
getgenv().Fly = false
getgenv().KillAura = false

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

-- ==================== FUNCTIONS ====================

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildWhichIsA("Humanoid")
end

local function GetRoot()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ==================== UNIVERSAL TAB ====================

local UniversalTab = Window:CreateTab("Universal", 4483362458)

UniversalTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        local hum = GetHumanoid()

        if hum then
            hum.WalkSpeed = Value
        end
    end,
})

UniversalTab:CreateInput({
    Name = "Enter WalkSpeed",
    PlaceholderText = "Type number...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        local hum = GetHumanoid()

        if num and hum then
            hum.WalkSpeed = num
        end
    end,
})

UniversalTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        local hum = GetHumanoid()

        if hum then
            hum.JumpPower = Value
        end
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
        local hum = GetHumanoid()

        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end,
})

UniversalTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

-- ==================== MM2 TAB ====================

if game.PlaceId == 142823291 then

    local MM2Tab = Window:CreateTab("MM2", 4483362458)

    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "MM2ESP"
    ESPFolder.Parent = game.CoreGui

    local function CreateESP(plr)
        if plr == LocalPlayer then
            return
        end

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = plr.Name
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(0, 250, 0, 60)
        Billboard.Enabled = false
        Billboard.Parent = ESPFolder

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.TextScaled = true
        Label.Font = Enum.Font.GothamBold
        Label.TextStrokeTransparency = 0
        Label.Parent = Billboard

        task.spawn(function()
            while Billboard.Parent and plr.Parent do
                pcall(function()

                    local char = plr.Character

                    if char and char:FindFirstChild("Head") then
                        Billboard.Adornee = char.Head
                    end

                    local backpack = plr:FindFirstChild("Backpack")

                    local hasKnife =
                        (char and char:FindFirstChild("Knife")) or
                        (backpack and backpack:FindFirstChild("Knife"))

                    local hasGun =
                        (char and char:FindFirstChild("Gun")) or
                        (backpack and backpack:FindFirstChild("Gun"))

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
                if gui:IsA("BillboardGui") then
                    gui.Enabled = state
                end
            end
        end,
    })

    MM2Tab:CreateButton({
        Name = "Auto Grab Gun",
        Callback = function()

            local root = GetRoot()

            if not root then
                return
            end

            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "GunDrop" or v.Name == "Gun" then

                    pcall(function()
                        firetouchinterest(root, v, 0)
                        firetouchinterest(root, v, 1)
                    end)
                end
            end
        end,
    })

    MM2Tab:CreateButton({
        Name = "Chat Expose Roles",
        Callback = function()

            for _, plr in pairs(Players:GetPlayers()) do

                local bp = plr:FindFirstChild("Backpack")

                if bp then

                    if bp:FindFirstChild("Knife") then
                        ReplicatedStorage
                            .DefaultChatSystemChatEvents
                            .SayMessageRequest
                            :FireServer(plr.Name .. " HAS THE KNIFE!", "All")
                    end

                    if bp:FindFirstChild("Gun") then
                        ReplicatedStorage
                            .DefaultChatSystemChatEvents
                            .SayMessageRequest
                            :FireServer(plr.Name .. " HAS THE GUN!", "All")
                    end
                end
            end
        end,
    })

    MM2Tab:CreateButton({
        Name = "Fling Murderer",
        Callback = function()

            for _, plr in pairs(Players:GetPlayers()) do

                if plr ~= LocalPlayer and plr.Character then

                    local backpack = plr:FindFirstChild("Backpack")

                    local hasKnife =
                        plr.Character:FindFirstChild("Knife") or
                        (backpack and backpack:FindFirstChild("Knife"))

                    if hasKnife then

                        local root = GetRoot()
                        local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")

                        if root and targetRoot then
                            root.AssemblyLinearVelocity =
                                (targetRoot.Position - root.Position).Unit * 350
                        end
                    end
                end
            end
        end,
    })

    MM2Tab:CreateButton({
        Name = "Fling Sheriff",
        Callback = function()

            for _, plr in pairs(Players:GetPlayers()) do

                if plr ~= LocalPlayer and plr.Character then

                    local backpack = plr:FindFirstChild("Backpack")

                    local hasGun =
                        plr.Character:FindFirstChild("Gun") or
                        (backpack and backpack:FindFirstChild("Gun"))

                    if hasGun then

                        local root = GetRoot()
                        local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")

                        if root and targetRoot then
                            root.AssemblyLinearVelocity =
                                (targetRoot.Position - root.Position).Unit * 350
                        end
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

                if plr ~= LocalPlayer and plr.Character then

                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

                    if hrp then
                        hrp.Size = Vector3.new(Value, Value, Value)
                        hrp.Transparency = 0.5
                        hrp.CanCollide = false
                    end
                end
            end
        end,
    })

end

-- ==================== GLOBAL LOGIC ====================

UIS.JumpRequest:Connect(function()

    if getgenv().InfiniteJump then

        local hum = GetHumanoid()

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.RenderStepped:Connect(function()

    -- Fly
    if getgenv().Fly then

        local root = GetRoot()

        if root then

            local move = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                move += Camera.CFrame.LookVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.S) then
                move -= Camera.CFrame.LookVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.A) then
                move -= Camera.CFrame.RightVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.D) then
                move += Camera.CFrame.RightVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                move += Vector3.new(0, 1, 0)
            end

            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                move -= Vector3.new(0, 1, 0)
            end

            if move.Magnitude > 0 then
                root.AssemblyLinearVelocity = move.Unit * 60
            else
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end

    -- Kill Aura
    if getgenv().KillAura then

        local root = GetRoot()

        if root then

            for _, plr in pairs(Players:GetPlayers()) do

                if plr ~= LocalPlayer and plr.Character then

                    local enemyRoot = plr.Character:FindFirstChild("HumanoidRootPart")

                    if enemyRoot then

                        local dist =
                            (enemyRoot.Position - root.Position).Magnitude

                        if dist < 15 then
                            root.CFrame =
                                enemyRoot.CFrame * CFrame.new(0, 0, 3)
                        end
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
