getgenv().Vex = {
    SilentAim = {
        Enabled = true,
        KeybindEnabled = false,
        Keybind = "X",
        Predict = true,
        Prediction = 0.1540234,
        AimPart = "HumanoidRootPart",
        LegitMode = true, -- nearest point
    },
    AimAssist = {
        Enabled = false,
        Keybind = "C",
        Predict = true,
        Prediction = 0.1267,
        Smoothness = 0.4,
        Aimpart = "HumanoidRootPart",
        LegitMode = false,
        DisableOnEnemyDeath = true,
        DisableOnOwnDeath = true,
        Shake = {
            Enabled = true,
            Strength = 100
        },
    },
    FOV = {
        SilentAim = {
            ShowFOV = true,
            KeybindEnabled = true,
            Keybind = "Z",
            Filled = false,
            FOV = 15,
            NumSides = 100,
            Color = Color3.fromRGB(255, 0, 0),
            Thickness = 1,
            Transparency = 0.7
        },
        AimAssist = {
            Enabled = false,
            ShowFOV = false,
            KeybindEnabled = false,
            Keybind = "M",
            Filled = false,
            FOV = 30,
            NumSides = 100,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 1,
            Transparency = 0.7
        }
    },
    Checks = {
        KOCheck = true,
        WallCheck = true,
        CrewCheck = false,
        FriendCheck = false,
        VelocityCheck = true
    },
    GunFOV = {
        Enabled = false,
        DoubleBarrel = 22.5,
        Revolver = 27.5,
        Shotgun = 35,
        TacticalShotgun = 35,
        Smg = 25,
        Rifle = 50,
        Silencer = 32.5,
        SilencerAR = 32.5,
        Glock = 100,
        AK47 = 25,
        AR = 42
    },
    Customize = {
        HitChance = {
            Enabled = false,
            GroundHitChance = 0,
            AirHitChance = 0
        },
        Prediction = {
            Enabled = false,
            GroundPrediction = 0,
            AirPrediction = 0
        },
        Smoothness = {
            Enabled = false,
            GroundSmoothness = 0,
            AirSmoothness = 0
        },
        Shake = {
            Enabled = false,
            GroundShake = 0,
            AirShake = 0
        }
    },
    RangeManagement = {
        Enabled = false,
        Type = "Both", 
        Close = {
            CloseDetection = 5,
            CloseFOV = 60,
            ClosePrediction = 0.121
        },
        Mid = {
            MidDetection = 15,
            MidFOV = 45,
            MidPrediction = 0.127
        },
        Far = {
            FarDetection = 25,
            FarFOV = 35,
            FarPrediction = 0.131
        },
        ReallyFar = {
            ReallyFarDetection = math.huge,
            ReallyFarFOV = 20,
            ReallyFarPrediction = 0.134
        }
    },
    Resolver = {
        Enabled = true,
        KeybindEnabled = false,
        Keybind = "K"
    },
    Chat = {
        Enabled = true, 
        FOV = ".fov",
        Prediction = ".prediction",
        HitChance = ".hitchance",
    },
    AutoPrediction = {
        ComingSoon = false,


    },
    Macro = {
        Type = "normal", -- normal/mouse
        Key = "q" -- keybind


    }

    
}



local Players = game:GetService("Players")
local Client = game:GetService("Players").LocalPlayer
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera
local Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
local SilentAimFOV = Drawing.new("Circle")
local AimAssistFOV = Drawing.new("Circle")
local SilentAimTarget
local AimAssistTarget

SilentAimFOV.Color = getgenv().Vex.FOV.SilentAim.Color
SilentAimFOV.Thickness = getgenv().Vex.FOV.SilentAim.Thickness
SilentAimFOV.Filled = getgenv().Vex.FOV.SilentAim.Filled
SilentAimFOV.Transparency = getgenv().Vex.FOV.SilentAim.Transparency
SilentAimFOV.NumSides = getgenv().Vex.FOV.SilentAim.NumSides

AimAssistFOV.Color = getgenv().Vex.FOV.AimAssist.Color
AimAssistFOV.Thickness = getgenv().Vex.FOV.AimAssist.Thickness
AimAssistFOV.Filled = getgenv().Vex.FOV.AimAssist.Filled
AimAssistFOV.Transparency = getgenv().Vex.FOV.AimAssist.Transparency
AimAssistFOV.NumSides = getgenv().Vex.FOV.AimAssist.NumSides

local UpdateFOV = function()
    if not SilentAimFOV and AimAssistFOV then
        return SilentAimFOV and AimAssistFOV
    end
    SilentAimFOV.Visible = getgenv().Vex.FOV.SilentAim.ShowFOV
    SilentAimFOV.Radius = getgenv().Vex.FOV.SilentAim.FOV * 5
    SilentAimFOV.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))

    AimAssistFOV.Visible = getgenv().Vex.FOV.AimAssist.ShowFOV
    AimAssistFOV.Radius = getgenv().Vex.FOV.AimAssist.FOV * 5
    AimAssistFOV.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
    return SilentAimFOV and AimAssistFOV
end
RunService.Heartbeat:Connect(UpdateFOV)

local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)
grmt.__index = newcclosure(function(self, v)
    if (getgenv().Vex.SilentAim.Enabled and Mouse and tostring(v) == "Hit") then
        if SilentAimTarget and SilentAimTarget.Character then
            if getgenv().Vex.SilentAim.Predict then
                local endpoint = game.Players[tostring(SilentAimTarget)].Character[getgenv().Vex.SilentAim.AimPart]
                                     .CFrame +
                                     (game.Players[tostring(SilentAimTarget)].Character[getgenv().Vex.SilentAim.AimPart]
                                         .Velocity * getgenv().Vex.SilentAim.Prediction)
                return (tostring(v) == "Hit" and endpoint)
            else
                local endpoint = game.Players[tostring(SilentAimTarget)].Character[getgenv().Vex.SilentAim.AimPart]
                                     .CFrame
                return (tostring(v) == "Hit" and endpoint)
            end
        end
    end
    return backupindex(self, v)
end)

local WorldToScreenPoint = function(Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end
local IsOnScreen = function(Object)
    local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
    return IsOnScreen
end
local NoMeshPart = function(Object)
    if string.find(Object.Name, "Gun") then
        return
    end
    if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
        return true
    end
end
local WallCheck = function(destination, ignore)
    local Origin = Camera.CFrame.p
    local CheckRay = Ray.new(Origin, destination - Origin)
    local Hit = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
    return Hit == nil
end
local PlayerMouseFunction = function()
    local Target, Closest = nil, 1 / 0
    for _, v in pairs(Players:GetPlayers()) do
        if getgenv().Vex.Checks.WallCheck then
            if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if (SilentAimFOV.Radius > Distance and Distance < Closest and OnScreen) and
                    WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
                    Closest = Distance
                    Target = v
                end
            end
        else
            if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if (SilentAimFOV.Radius > Distance and Distance < Closest and OnScreen) then
                    Closest = Distance
                    Target = v
                end
            end
        end
    end
    return Target
end
local PlayerMouseFunction2 = function()
    local Target, Closest = nil, AimAssistFOV.Radius * 1.27
    for _, v in pairs(Players:GetPlayers()) do
        if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
            if getgenv().Vex.Checks.WallCheck then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < Closest and OnScreen) and
                    WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
                    Closest = Distance
                    Target = v
                end
            else
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < Closest and OnScreen) then
                    Closest = Distance
                    Target = v
                end
            end
        end
    end
    return Target
end
local BodyPartFunction = function(character)
    local ClosestDistance = 1 / 0
    local BodyPart = nil
    if (character and character:GetChildren()) then
        for _, x in next, character:GetChildren() do
            if NoMeshPart(x) and IsOnScreen(x) then
                local Distance = (WorldToScreenPoint(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (SilentAimFOV.Radius > Distance and Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end
local BodyPartFunction2 = function(character)
    local ClosestDistance = 1 / 0
    local BodyPart = nil

    if (character and character:GetChildren()) then
        for _, x in next, character:GetChildren() do
            if NoMeshPart(x) and IsOnScreen(x) then
                local Distance = (WorldToScreenPoint(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end
task.spawn(function()
    while task.wait() do
        if getgenv().Vex.SilentAim.Enabled then
            SilentAimTarget = PlayerMouseFunction()
        end
        if AimAssistTarget then
            if getgenv().Vex.AimAssist.Enabled and (AimAssistTarget.Character) and
                getgenv().Vex.AimAssist.LegitMode then
                getgenv().Vex.AimAssist.Aimpart = tostring(BodyPartFunction2(AimAssistTarget.Character))
            end
        end
        if SilentAimTarget then
            if getgenv().Vex.SilentAim.Enabled and (SilentAimTarget.Character) and
                getgenv().Vex.SilentAim.LegitMode then
                getgenv().Vex.SilentAim.AimPart = tostring(BodyPartFunction(SilentAimTarget.Character))
            end
        end
    end
end)
Mouse.KeyDown:Connect(function(Key)
    if getgenv().Vex.FOV.SilentAim.KeybindEnabled then
        if (Key == getgenv().Vex.FOV.SilentAim.Keybind:lower()) then
            if getgenv().Vex.FOV.SilentAim.ShowFOV == true then
                getgenv().Vex.FOV.SilentAim.ShowFOV = false
            else
                getgenv().Vex.FOV.SilentAim.ShowFOV = true
            end
            if getgenv().Vex.FOV.AimAssist.KeybindEnabled then
                if (Key == getgenv().Vex.FOV.AimAssist.Keybind:lower()) then
                    if getgenv().Vex.FOV.AimAssist.ShowFOV == true then
                        getgenv().Vex.FOV.AimAssist.ShowFOV = false
                    else
                        getgenv().Vex.FOV.AimAssist.ShowFOV = true
                    end
                end
                if getgenv().Vex.SilentAim.KeybindEnabled then
                    if (Key == getgenv().Vex.SilentAim.Keybind:lower()) then
                        if getgenv().Vex.SilentAim.Enabled == true then
                            getgenv().Vex.SilentAim.Enabled = false
                        else
                            getgenv().Vex.SilentAim.Enabled = true
                        end
                    end
                end
            end
        end
        if (Key == getgenv().Vex.AimAssist.Keybind:lower()) then
            if getgenv().Vex.AimAssist.Enabled == true then
                IsTargetting = not IsTargetting
                if IsTargetting then
                    AimAssistTarget = PlayerMouseFunction2()
                else
                    if AimAssistTarget ~= nil then
                        AimAssistTarget = nil
                        IsTargetting = false
                    end
                end
            end
        end
    end
    if getgenv().Vex.Resolver.KeybindEnabled then
        if (Key == getgenv().Vex.Resolver.Keybind:lower()) then
            if getgenv().Vex.Resolver.Enabled == true then
                getgenv().Vex.Resolver.Enabled = false
            else
                getgenv().Vex.Resolver.Enabled = true
            end
        end
    end
end)
if getgenv().Vex.Checks.CrewCheck then
    while true do
        local newPlayer = game.Players.PlayerAdded:wait()
        if player:IsInGroup(newPlayer.Group) then
            table.insert(Ignored.Players, newPlayer)
        end
    end
end
if getgenv().Vex.Checks.FriendCheck then
    game.Players.PlayerAdded:Connect(function(SilentAimTarget)
        if Client:IsFriendsWith(SilentAimTarget) then
            local newPlayer = game.Players.PlayerAdded:wait()
            table.insert(Ignored.Players, newPlayer)
        end
    end)
end





function TargetLegitness(Target)
    if getgenv().Vex.Checks.KOCheck == true and Target.Character then
    return Target.Character.BodyEffects["K.O"].Value and true or false
    end
    return false
    end

    function PredictionictTargets(Target, Value)
    return Target.Character[getgenv().Vex.SilentAim.AimPart].CFrame +
    (Target.Character.Humanoid.MoveDirection * Value * 16)
    end









    local grmt = getrawmetatable(game)
    local backupindex = grmt.index
    setreadonly(grmt, false)
    
    grmt.index = newcclosure(function(self, v)
        if (Settings.Silent.Enabled and Mouse and tostring(v) == "Hit") then
    
            Prey = ClosestPlrFromMouse()
    
            if Prey then
                local endpoint = game.Players[tostring(Prey)].Character[Vex.SilentAim.AimPart].CFrame + (
                    game.Players[tostring(Prey)].Character[Vex.SilentAim.AimPart].Velocity * Vex.SilentAim.Prediction
                )
                return (tostring(v) == "Hit" and endpoint)
            end
        end
        return backupindex(self, v)
    end)
    
            local grmt = getrawmetatable(game)
            local index = grmt.index
            local properties = {
                "Hit"
            }
            setreadonly(grmt, false)
    
            grmt.index =
                newcclosure(
                function(self, v)
                    if Mouse and (table.find(properties, v)) then
                        prey = GetClosestToMouse()
                        if prey ~= nil and getgenv().Vex.SilentAim.Enabled and not TargetChecks(prey) then
                            local endpoint = predictTargets(prey, getgenv().Vex.SilentAim.Prediction)
    
                            return (table.find(properties, tostring(v)) and endpoint)
                        end
                    end
                    return index(self, v)
                end
            )





































getgenv().Extra = {
    ["Enabled"] = (getgenv().Vex.GunFOV.Enabled),
    ["Double-Barrel SG"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.DoubleBarrel)
    },
    ["DoubleBarrel"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.DoubleBarrel)
    },
    ["Revolver"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.Revolver)
    },
    ["SMG"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.Smg)
    },
    ["Shotgun"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.Shotgun)
    },
    ["TacticalShotgun"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.TacticalShotgun)
    },
    ["Rifle"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.Rifle)
    },
    ["Silencer"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.Silencer)
    },
    ["SilencerAR"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.SilencerAR)
    },
    ["Glock"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.Glock)
    },
    ["AK47"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.AK47)
    },
    ["AR"] = {
        ["FOV"] = (getgenv().Vex.GunFOV.AR)
    }
}

local Script = {
    Functions = {}
}
Script.Functions.getToolName = function(name)
    local split = string.split(string.split(name, "[")[2], "]")[1]
    return split
end
Script.Functions.getEquippedWeaponName = function()
    if (Client.Character) and Client.Character:FindFirstChildWhichIsA("Tool") then
        local Tool = Client.Character:FindFirstChildWhichIsA("Tool")
        if string.find(Tool.Name, "%[") and string.find(Tool.Name, "%]") and not string.find(Tool.Name, "Wallet") and
            not string.find(Tool.Name, "Phone") then
            return Script.Functions.getToolName(Tool.Name)
        end
    end
    return nil
end
RunService.RenderStepped:Connect(function()
    if getgenv().Vex.SilentAim.Enabled then
        if getgenv().Vex.Checks.KOCheck == true and SilentAimTarget and SilentAimTarget.Character then
            local KOd = SilentAimTarget.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = SilentAimTarget.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                SilentAimTarget = nil
            end
        end
    end
    if getgenv().Vex.AimAssist.Enabled == true then
        if getgenv().Vex.Checks.KOCheck == true and AimAssistTarget and AimAssistTarget.Character then
            local KOd = AimAssistTarget.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = AimAssistTarget.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                AimAssistTarget = nil
                IsTargetting = false
            end
        end
    end
    if getgenv().Vex.AimAssist.DisableOnEnemyDeath == true and AimAssistTarget and
    AimAssistTarget.Character:FindFirstChild("Humanoid") then
        if AimAssistTarget.Character.Humanoid.health < 2 then
            AimAssistTarget = nil
            IsTargetting = false
        end
    end
    if getgenv().Vex.AimAssist.DisableOnOwnDeath == true and AimAssistTarget and
    AimAssistTarget.Character:FindFirstChild("Humanoid") then
        if Client.Character.Humanoid.health < 2 then
            AimAssistTarget = nil
            IsTargetting = false
        end
    end
    if getgenv().Vex.FOV.AimAssist.Enabled == true and AimAssistTarget and AimAssistTarget.Character and
    AimAssistTarget.Character:WaitForChild("HumanoidRootPart") then
        if AimAssistFOV.Radius < (Vector2.new(Camera:WorldToScreenPoint(AimAssistTarget.Character.HumanoidRootPart.Position).X,
            Camera:WorldToScreenPoint(AimAssistTarget.Character.HumanoidRootPart.Position).Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude then
                AimAssistTarget = nil
            IsTargetting = false
        end
    end
    if getgenv().Vex.AimAssist.Predict and AimAssistTarget and AimAssistTarget.Character and
    AimAssistTarget.Character:FindFirstChild(getgenv().Vex.AimAssist.Aimpart) then
        if getgenv().Vex.AimAssist.Shake.Enabled then
            local Main = CFrame.new(Camera.CFrame.p,
            AimAssistTarget.Character[getgenv().Vex.AimAssist.Aimpart].Position +
                AimAssistTarget.Character[getgenv().Vex.AimAssist.Aimpart].Velocity *
                    getgenv().Vex.AimAssist.Prediction +
                    Vector3.new(math.random(-getgenv().Vex.AimAssist.Shake.Strength,
                        getgenv().Vex.AimAssist.Shake.Strength), math.random(
                        -getgenv().Vex.AimAssist.Shake.Strength,
                        getgenv().Vex.AimAssist.Shake.Strength), math.random(
                        -getgenv().Vex.AimAssist.Shake.Strength,
                        getgenv().Vex.AimAssist.Shake.Strength)) * 0.1)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Vex.AimAssist.Smoothness / 2,
                Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        else
            local Main = CFrame.new(Camera.CFrame.p,
            AimAssistTarget.Character[getgenv().Vex.AimAssist.Aimpart].Position +
                AimAssistTarget.Character[getgenv().Vex.AimAssist.Aimpart].Velocity *
                    getgenv().Vex.AimAssist.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Vex.AimAssist.Smoothness / 2,
                Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
    elseif getgenv().Vex.AimAssist.Predict == false and AimAssistTarget and AimAssistTarget.Character and
    AimAssistTarget.Character:FindFirstChild(getgenv().Vex.AimAssist.Aimpart) then
        if getgenv().Vex.AimAssist.Shake.Enabled then
            local Main = CFrame.new(Camera.CFrame.p,
            AimAssistTarget.Character[getgenv().Vex.AimAssist.Aimpart].Position +
                    Vector3.new(math.random(-getgenv().Vex.AimAssist.Shake.Strength,
                        getgenv().Vex.AimAssist.Shake.Strength), math.random(
                        -getgenv().Vex.AimAssist.Shake.Strength,
                        getgenv().Vex.AimAssist.Shake.Strength), math.random(
                        -getgenv().Vex.AimAssist.Shake.Strength,
                        getgenv().Vex.AimAssist.Shake.Strength)) * 0.1)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Vex.AimAssist.Smoothness / 2,
                Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        else
            local Main =
                CFrame.new(Camera.CFrame.p, AimAssistTarget.Character[getgenv().Vex.AimAssist.Aimpart].Position)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Vex.AimAssist.Smoothness / 2,
                Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
    end
    if Script.Functions.getEquippedWeaponName() ~= nil then
        local WeaponSettings = getgenv().Extra[Script.Functions.getEquippedWeaponName()]
        if WeaponSettings ~= nil and getgenv().Vex.GunFOV.Enabled == true then
            getgenv().Vex.FOV.SilentAim.FOV = WeaponSettings.FOV
        else
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.FOV.SilentAim.FOV
        end
    end
     if getgenv().Vex.RangeManagement.Enabled and getgenv().Vex.RangeManagement.Type == "Both" and Client ~= nil and
        (Client.Character) and SilentAimTarget and SilentAimTarget.Character then
        if (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Close.CloseDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.Close.CloseFOV
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.Close.ClosePrediction

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Mid.MidDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.Mid.MidFOV
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.Mid.MidPrediction

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Far.FarDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.Far.FarFOV
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.Far.FarPrediction

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.ReallyFar.ReallyFarDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.ReallyFar.ReallyFarFOV
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.ReallyFar.ReallyFarPrediction

        end
    end
    if getgenv().Vex.RangeManagement.Enabled and getgenv().Vex.RangeManagement.Type == "Prediction" and Client ~= nil and
        (Client.Character) and SilentAimTarget and SilentAimTarget.Character then
        if (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Close.CloseDetection then
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.Close.ClosePrediction

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Mid.MidDetection then
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.Mid.MidPrediction

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Far.FarDetection then
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.Far.FarPrediction

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.ReallyFar.ReallyFarDetection then
            getgenv().Vex.SilentAim.Prediction = getgenv().Vex.RangeManagement.ReallyFar.ReallyFarPrediction

        end
    end
    if getgenv().Vex.RangeManagement.Enabled and getgenv().Vex.RangeManagement.Type == "FOV" and Client ~= nil and
        (Client.Character) and SilentAimTarget and SilentAimTarget.Character then
        if (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Close.CloseDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.Close.CloseFOV

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Mid.MidDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.Mid.MidFOV

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.Far.FarDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.Far.FarFOV

        elseif (Client.Character.HumanoidRootPart.Position - SilentAimTarget.Character.HumanoidRootPart.Position).Magnitude <
            getgenv().Vex.RangeManagement.ReallyFar.ReallyFarDetection then
            getgenv().Vex.FOV.SilentAim.FOV = getgenv().Vex.RangeManagement.ReallyFar.ReallyFarFOV

        end
    end
end)
if getgenv().Vex.Customize.HitChance.Enabled then
    if SilentAimTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        getgenv().Vex.SilentAim.HitChance = getgenv().Vex.Customize.HitChance.AirHitChance
    else
        getgenv().Vex.SilentAim.HitChance = getgenv().Vex.Customize.HitChance.GroundHitChance
    end
end
if getgenv().Vex.Customize.Prediction.Enabled then
    if SilentAimTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        getgenv().Vex.SilentAim.Prediction = getgenv().Vex.Customize.Prediction.AirPrediction
    else
        getgenv().Vex.SilentAim.Prediction = getgenv().Vex.Customize.Prediction.GroundPrediction
    end
end
if getgenv().Vex.Customize.Smoothness.Enabled then
    if AimAssistTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        getgenv().Vex.AimAssist.Smoothness = getgenv().Vex.Customize.Smoothness.AirSmoothness
    else
        getgenv().Vex.AimAssist.Smoothness = getgenv().Vex.Customize.Smoothness.GroundSmoothness
    end
end
if getgenv().Vex.Customize.Shake.Enabled then
    if AimAssistTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        getgenv().Vex.AimAssist.Shake.Strength = getgenv().Vex.Customize.Shake.AirShake
    else
        getgenv().Vex.AimAssist.Shake.Strength = getgenv().Vex.Customize.Shake.GroundShake
    end
end
Client.Chatted:Connect(function(message)
    if getgenv().Vex.Chat.Enabled then
        local args = string.split(message, " ")
        if args[1] == getgenv().Vex.Chat.FOV and args[2] ~= nil then
            getgenv().Vex.FOV.SilentAim.FOV = tonumber(args[2])
        end
    end
    if getgenv().Vex.Chat.Enabled then
        local args = string.split(message, " ")
        if args[1] == getgenv().Vex.Chat.Prediction and args[2] ~= nil then
            getgenv().Vex.SilentAim.Prediction = tonumber(args[2])
        end
    end
    if getgenv().Vex.Chat.Enabled then
        local args = string.split(message, " ")
        if args[1] == getgenv().Vex.Chat.HitChance and args[2] ~= nil then
            getgenv().Vex.SilentAim.HitChance = tonumber(args[2])
        end
    end
end)


-- Define a function that finds the nearest point
    function findNearestPoint(position)
        local nearestPoint = nil
        local shortestDistance = math.huge -- set an initial value that is very large
    
        -- Loop through all the parts in the workspace
        for _, part in ipairs(workspace:GetParts()) do
            -- Calculate the distance between the part and the given position
            local distance = (part.Position - position).Magnitude
    
            -- Update the nearest point if the current part is closer
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPoint = part.Position
            end
        end
    
        return nearestPoint
    end
    
    -- Example usage:
    local position = Vector3.new(10, 5, 3)
    local nearestPoint = findNearestPoint(position)
    getgenv().macrospeed = 1



local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local SpeedGlitch = false
Mouse.KeyDown:Connect(function(Key)
    if Key == (Vex.Macro.Key) and Vex.Macro.Type == "normal" then
    SpeedGlitch = not SpeedGlitch
    if SpeedGlitch == true then
    repeat task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "I", false, game)
    task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "O", false, game)
    task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "I", false, game)
    task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "O", false, game)
    task.wait(macrospeed / 100)
    until SpeedGlitch == false
end
end
end)
    Mouse.KeyDown:Connect(function(Key)
    if Key == (Vex.Macro.Key) and Vex.Macro.Type == "mouse" then
    SpeedGlitch = not SpeedGlitch
    if SpeedGlitch == true then
    repeat task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", true, game)
    task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", false, game)
    task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", true, game)
    task.wait(macrospeed / 100)
    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", false, game)
    task.wait(macrospeed / 100)
    until SpeedGlitch == false
end
end
end)
