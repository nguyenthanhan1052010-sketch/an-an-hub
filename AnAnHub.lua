local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 2)

if not PlayerGui then return end

if PlayerGui:FindFirstChild("AnAnHubRadar") then
    PlayerGui.AnAnHubRadar:Destroy()
end

local RadarGui = Instance.new("ScreenGui")
RadarGui.Name = "AnAnHubRadar"
RadarGui.ResetOnSpawn = false

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TopBar.BackgroundTransparency = 0.4
TopBar.BorderSizePixel = 0
TopBar.Parent = RadarGui

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.Position = UDim2.new(0, 0, 1, -2)
TopLine.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
TopLine.BorderSizePixel = 0
TopLine.Parent = TopBar

local TopText = Instance.new("TextLabel")
TopText.Size = UDim2.new(1, 0, 1, 0)
TopText.BackgroundTransparency = 1
TopText.Text = "☀️ AN AN LÀ MẶT TRỜI NHỎ HUB — KING LEGACY SYSTEM ☀️"
TopText.TextColor3 = Color3.fromRGB(255, 230, 150)
TopText.TextSize = 11
TopText.Font = Enum.Font.Code
TopText.Parent = TopBar

local AnimePanel = Instance.new("Frame")
AnimePanel.Size = UDim2.new(0, 210, 0, 140)
AnimePanel.Position = UDim2.new(0.03, 0, 0.08, 0)
AnimePanel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
AnimePanel.BackgroundTransparency = 0.25
AnimePanel.Parent = RadarGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = AnimePanel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Color3.fromRGB(255, 215, 0)
PanelStroke.Thickness = 1.5
PanelStroke.Parent = AnimePanel

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(1, 0, 0, 30)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "☀️ AN AN HUB ACTIVE"
PanelTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
PanelTitle.TextSize = 13
PanelTitle.Font = Enum.Font.SourceSansBold
PanelTitle.Parent = AnimePanel

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 1, -35)
InfoLabel.Position = UDim2.new(0, 10, 0, 35)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "• SEA KING: ĐANG TÍNH...\n• GHOST SHIP: ĐANG TÍNH...\n• HYDRA: CHỜ SỰ KIỆN"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.SourceSansBold
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.LineHeight = 1.4
InfoLabel.Parent = AnimePanel

local RadarFrame = Instance.new("Frame")
RadarFrame.Size = UDim2.new(0, 160, 0, 160)
RadarFrame.Position = UDim2.new(0.5, -80, 0.75, -80)
RadarFrame.BackgroundTransparency = 1
RadarFrame.Parent = RadarGui

RadarGui.Parent = PlayerGui

local function CreateRadarText(name, text, color, size)
    local Label = Instance.new("TextLabel")
    Label.Name = name
    Label.Size = UDim2.new(0, 30, 0, 30)
    Label.AnchorPoint = Vector2.new(0.5, 0.5)
    Label.Position = UDim2.new(0.5, 0, 0.5, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextSize = size or 16
    Label.Font = Enum.Font.SourceSansBold
    Label.TextColor3 = color
    return Label
end

local function FindOceanEvent()
    for _, obj in pairs(Workspace:GetChildren()) do
        local name = string.lower(obj.Name)
        if string.find(name, "sea king") or string.find(name, "ghost ship") or string.find(name, "beast") or string.find(name, "hydra") then
            if obj:FindFirstChild("HumanoidRootPart") then
                return obj.HumanoidRootPart, obj.Name
            elseif obj:IsA("BasePart") then
                return obj, obj.Name
            end
        end
    end
    return nil, ""
end

local function UpdateTimeLabels(activeName)
    local min = os.date("*t").min
    local skTime = 60 - min
    local gsTime = 45 - min
    if gsTime < 0 then gsTime = gsTime + 60 end
    
    if activeName ~= "" then
        local n = string.lower(activeName)
        if string.find(n, "sea king") then
            InfoLabel.Text = "• SEA KING: 🌟 ĐANG CÓ!\n• GHOST SHIP: Chờ " .. gsTime .. "m\n• HYDRA: CHỜ SỰ KIỆN"
        elseif string.find(n, "ghost ship") then
            InfoLabel.Text = "• SEA KING: Chờ " .. skTime .. "m\n• GHOST SHIP: 🌟 ĐANG CÓ!\n• HYDRA: CHỜ SỰ KIỆN"
        elseif string.find(n, "hydra") then
            InfoLabel.Text = "• SEA KING: Chờ " .. skTime .. "m\n• GHOST SHIP: Chờ " .. gsTime .. "m\n• HYDRA: 🌟 ĐANG CÓ!"
        end
    else
        InfoLabel.Text = "• SEA KING: Khoảng " .. skTime .. "m nữa\n• GHOST SHIP: Khoảng " .. gsTime .. "m nữa\n• HYDRA: CHỜ SỰ KIỆN"
    end
end

local CurrentState = nil
local RenderConnection
RenderConnection = RunService.RenderStepped:Connect(function()
    if not RadarGui or not RadarGui.Parent or not RadarFrame then
        return
    end

    local char = LocalPlayer.Character
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    
    local Target, targetName = FindOceanEvent()
    UpdateTimeLabels(targetName)
    
    if not myHrp or not Camera then 
        return 
    end
    
    if Target then
        if CurrentState ~= "Tracking" then
            RadarFrame:ClearAllChildren()
            local MainArrow = CreateRadarText("MainArrow", "▲", Color3.fromRGB(255, 215, 0), 32)
            MainArrow.Parent = RadarFrame
            CurrentState = "Tracking"
        end
        
        local MainArrow = RadarFrame:FindFirstChild("MainArrow")
        if MainArrow then
            local camLook = Camera.CFrame.LookVector
            local flatCamLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
            
            local dirToTarget = (Target.Position - myHrp.Position).Unit
            local flatDir = Vector3.new(dirToTarget.X, 0, dirToTarget.Z).Unit
            
            local angle = math.atan2(flatDir.X, flatDir.Z) - math.atan2(flatCamLook.X, flatCamLook.Z)
            MainArrow.Rotation = math.deg(angle)
            RadarFrame.Rotation = 0
        end
    else
        if CurrentState ~= "Idle" then
            RadarFrame:ClearAllChildren()
            
            local N = CreateRadarText("N", "N", Color3.fromRGB(255, 75, 75), 22)
            local E = CreateRadarText("E", "E", Color3.fromRGB(255, 255, 255), 18)
            local S = CreateRadarText("S", "S", Color3.fromRGB(255, 255, 255), 18)
            local W = CreateRadarText("W", "W", Color3.fromRGB(255, 255, 255), 18)
            
            local NE = CreateRadarText("NE", "NE", Color3.fromRGB(200, 200, 200), 12)
            local SE = CreateRadarText("SE", "SE", Color3.fromRGB(200, 200, 200), 12)
            local SW = CreateRadarText("SW", "SW", Color3.fromRGB(200, 200, 200), 12)
            local NW = CreateRadarText("NW", "NW", Color3.fromRGB(200, 200, 200), 12)
            
            local radiusMain = 50
            local radiusSub = 48
            
            N.Position = UDim2.new(0.5, 0, 0.5, -radiusMain)
            E.Position = UDim2.new(0.5, radiusMain, 0.5, 0)
            S.Position = UDim2.new(0.5, 0, 0.5, radiusMain)
            W.Position = UDim2.new(0.5, -radiusMain, 0.5, 0)
            
            local offset = radiusSub * math.sin(math.rad(45))
            NE.Position = UDim2.new(0.5, offset, 0.5, -offset)
            SE.Position = UDim2.new(0.5, offset, 0.5, offset)
            SW.Position = UDim2.new(0.5, -offset, 0.5, offset)
            NW.Position = UDim2.new(0.5, -offset, 0.5, -offset)
            
            N.Parent = RadarFrame
            E.Parent = RadarFrame
            S.Parent = RadarFrame
            W.Parent = RadarFrame
            NE.Parent = RadarFrame
            SE.Parent = RadarFrame
            SW.Parent = RadarFrame
            NW.Parent = RadarFrame
            
            CurrentState = "Idle"
        end
        
        local camLook = Camera.CFrame.LookVector
        local angle = math.atan2(camLook.X, camLook.Z)
        RadarFrame.Rotation = math.deg(angle) + 180
    end
end)
