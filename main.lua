--// ================= SERVICES ================= //

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--// ================= RAYFIELD ================= //

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Universal Hub | Reworked",
    LoadingTitle = "Universal Hub",
    LoadingSubtitle = "MM2 Edition",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalHub",
        FileName = "UniversalHubConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

--// ================= VARIABLES ================= //

getgenv().UH = {
    Fly = false,
    Noclip = false,
    InfiniteJump = false,
    Spinbot = false,
    KillAura = false,
    ESP = false,
    FullBright = false,
    Speed = 16,
    Jump = 50,
    FlySpeed = 70,
    Hitbox = 5
}

--// ================= FUNCTIONS ================= //

local function Character()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function Humanoid()
    return Character():FindFirstChildWhichIsA("Humanoid")
end

local function Root()
    return Character():FindFirstChild("HumanoidRootPart")
end

local function Notify(title, text)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = 4,
        Image = 4483362458
    })
end

local function GetRole(plr)
    local char = plr.Character
    local backpack = plr:FindFirstChild("Backpack")

    if not char then
        return "INNOCENT"
    end

    local hasKnife =
        char:FindFirstChild("Knife") or
        (backpack and backpack:FindFirstChild("Knife"))

    local hasGun =
        char:FindFirstChild("Gun") or
        (backpack and backpack:FindFirstChild("Gun"))

    if hasKnife then
        return "MURDERER"
    elseif hasGun then
        return "SHERIFF"
    end

    return "INNOCENT"
end

--// ================= FLING ================= //

local function Fling(target)
    if not target then
        return
    end

    if not target.Character then
        return
    end

    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = Root()

    if not targetRoot or not myRoot then
        return
    end

    local old = myRoot.CFrame

    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.Parent = myRoot

    local BG = Instance.new("BodyAngularVelocity")
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.AngularVelocity = Vector3.new(99999, 99999, 99999)
    BG.Parent = myRoot

    for _ = 1, 60 do
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1)
        myRoot.AssemblyLinearVelocity = targetRoot.CFrame.LookVector * 10000
        RunService.Heartbeat:Wait()
    end

    BV:Destroy()
    BG:Destroy()

    myRoot.CFrame = old
end

--// ================= UNIVERSAL TAB ================= //

local Universal = Window:CreateTab("Universal", 4483362458)

Universal:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        UH.Speed = v

        local hum = Humanoid()

        if hum then
            hum.WalkSpeed = v
        end
    end,
})

Universal:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v)
        UH.Jump = v

        local hum = Humanoid()

        if hum then
            hum.JumpPower = v
        end
    end,
})

Universal:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 300},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(v)
        UH.FlySpeed = v
    end,
})

Universal:CreateSlider({
    Name = "FOV",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(v)
        Camera.FieldOfView = v
    end,
})

Universal:CreateSlider({
    Name = "Gravity",
    Range = {0, 196},
    Increment = 1,
    CurrentValue = workspace.Gravity,
    Callback = function(v)
        workspace.Gravity = v
    end,
})

Universal:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        UH.Fly = v
    end,
})

Universal:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        UH.Noclip = v
    end,
})

Universal:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        UH.InfiniteJump = v
    end,
})

Universal:CreateToggle({
    Name = "Spinbot",
    CurrentValue = false,
    Callback = function(v)
        UH.Spinbot = v
    end,
})

Universal:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Callback = function(v)
        UH.FullBright = v
    end,
})

Universal:CreateButton({
    Name = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end

        Notify("FPS", "FPS Boost Enabled")
    end,
})

Universal:CreateButton({
    Name = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

Universal:CreateButton({
    Name = "Server Hop",
    Callback = function()
        TeleportService:Teleport(game.PlaceId)
    end,
})

Universal:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local hum = Humanoid()

        if hum then
            hum.Health = 0
        end
    end,
})

Universal:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})

--// ================= PLAYER TAB ================= //

local PlayerTab = Window:CreateTab("Players", 4483362458)

local SelectedPlayer = nil

PlayerTab:CreateInput({
    Name = "Player Username",
    PlaceholderText = "Enter Username",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt)
        for _, plr in pairs(Players:GetPlayers()) do
            if string.find(string.lower(plr.Name), string.lower(txt)) then
                SelectedPlayer = plr
                Notify("Player", "Selected: " .. plr.Name)
                break
            end
        end
    end,
})

PlayerTab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        if SelectedPlayer and SelectedPlayer.Character then
            local targetRoot = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")

            if targetRoot and Root() then
                Root().CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end,
})

PlayerTab:CreateButton({
    Name = "Fling Player",
    Callback = function()
        if SelectedPlayer then
            Fling(SelectedPlayer)
        end
    end,
})

--// ================= MM2 TAB ================= //

if game.PlaceId == 142823291 then

    local MM2 = Window:CreateTab("MM2", 4483362458)

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
        Billboard.Size = UDim2.new(0, 200, 0, 50)
        Billboard.Enabled = false
        Billboard.Parent = ESPFolder

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.TextScaled = true
        Label.Font = Enum.Font.GothamBold
        Label.TextStrokeTransparency = 0
        Label.Parent = Billboard

        task.spawn(function()
            while Billboard.Parent do
                local char = plr.Character
                local head = char and char:FindFirstChild("Head")

                if head then
                    Billboard.Adornee = head
                end

                local role = GetRole(plr)

                if role == "MURDERER" then
                    Label.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif role == "SHERIFF" then
                    Label.TextColor3 = Color3.fromRGB(0, 100, 255)
                else
                    Label.TextColor3 = Color3.fromRGB(0, 255, 100)
                end

                Label.Text = plr.Name .. " [" .. role .. "]"

                task.wait(0.3)
            end
        end)
    end

    for _, plr in pairs(Players:GetPlayers()) do
        CreateESP(plr)
    end

    Players.PlayerAdded:Connect(CreateESP)

    MM2:CreateToggle({
        Name = "Role ESP",
        CurrentValue = false,
        Callback = function(v)
            UH.ESP = v

            for _, gui in pairs(ESPFolder:GetChildren()) do
                if gui:IsA("BillboardGui") then
                    gui.Enabled = v
                end
            end
        end,
    })

    MM2:CreateToggle({
        Name = "Kill Aura",
        CurrentValue = false,
        Callback = function(v)
            UH.KillAura = v
        end,
    })

    MM2:CreateSlider({
        Name = "Hitbox Size",
        Range = {2, 30},
        Increment = 1,
        CurrentValue = 5,
        Callback = function(v)
            UH.Hitbox = v
        end,
    })

    MM2:CreateButton({
        Name = "Auto Grab Gun",
        Callback = function()
            local root = Root()

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

    MM2:CreateButton({
        Name = "Fling Murderer",
        Callback = function()
            for _, plr in pairs(Players:GetPlayers()) do
                if GetRole(plr) == "MURDERER" then
                    Fling(plr)
                end
            end
        end,
    })

    MM2:CreateButton({
        Name = "Fling Sheriff",
        Callback = function()
            for _, plr in pairs(Players:GetPlayers()) do
                if GetRole(plr) == "SHERIFF" then
                    Fling(plr)
                end
            end
        end,
    })

end

--// ================= CTRL CLICK TP ================= //

Mouse.Button1Down:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        if Root() then
            Root().CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 5, 0))
        end
    end
end)

--// ================= INFINITE JUMP ================= //

UIS.JumpRequest:Connect(function()
    if UH.InfiniteJump then
        local hum = Humanoid()

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--// ================= MAIN LOOP ================= //

RunService.RenderStepped:Connect(function()

    local char = Character()
    local root = Root()

    -- Fly
    if UH.Fly and root then
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
            root.AssemblyLinearVelocity = move.Unit * UH.FlySpeed
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end

    -- Noclip
    if UH.Noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    -- Spinbot
    if UH.Spinbot and root then
        root.CFrame *= CFrame.Angles(0, math.rad(25), 0)
    end

    -- FullBright
    if UH.FullBright then
        Lighting.Brightness = 5
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end

    -- Kill Aura
    if UH.KillAura and root then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local enemyRoot = plr.Character:FindFirstChild("HumanoidRootPart")

                if enemyRoot then
                    local dist = (enemyRoot.Position - root.Position).Magnitude

                    if dist < 15 then
                        root.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 2)
                    end
                end
            end
        end
    end

    -- Hitbox Expander
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

            if hrp then
                hrp.Size = Vector3.new(UH.Hitbox, UH.Hitbox, UH.Hitbox)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            end
        end
    end

end)

Notify("Universal Hub", "Loaded Successfully")

