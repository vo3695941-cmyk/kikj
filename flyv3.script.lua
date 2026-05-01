local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local close = Instance.new("TextButton")

-- Menu chuyển Tab
local TabContainer = Instance.new("Frame")
local FlyTabBtn = Instance.new("TextButton")
local ToolTabBtn = Instance.new("TextButton")

-- Các trang nội dung
local FlyPage = Instance.new("Frame")
local ToolPage = Instance.new("ScrollingFrame") 

main.Name = "XNEO_HUB_V3"
main.Parent = game.CoreGui
main.ResetOnSpawn = false

-- Khung chính Cam - Đen
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 200, 0, 200)
Frame.Active = true
Frame.Draggable = true 

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", Frame)
stroke.Color = Color3.fromRGB(255, 140, 0)
stroke.Thickness = 2

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "XNEO HUB V3"
Title.TextColor3 = Color3.fromRGB(255, 140, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- Thanh chọn Tab
TabContainer.Parent = Frame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 0, 0.18, 0)
TabContainer.Size = UDim2.new(1, 0, 0, 25)

FlyTabBtn.Parent = TabContainer
FlyTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
FlyTabBtn.Text = "Bay"
FlyTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", FlyTabBtn)

ToolTabBtn.Parent = TabContainer
ToolTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
ToolTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
ToolTabBtn.Text = "Công cụ"
ToolTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToolTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
Instance.new("UICorner", ToolTabBtn)

-- Trang nội dung
FlyPage.Parent = Frame
FlyPage.BackgroundTransparency = 1
FlyPage.Position = UDim2.new(0, 0, 0.35, 0)
FlyPage.Size = UDim2.new(1, 0, 0.65, 0)

ToolPage.Parent = Frame
ToolPage.BackgroundTransparency = 1
ToolPage.Position = UDim2.new(0, 0, 0.35, 0)
ToolPage.Size = UDim2.new(1, 0, 0.65, 0)
ToolPage.Visible = false
ToolPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ToolPage.ScrollBarThickness = 0

local listLayout = Instance.new("UIListLayout", ToolPage)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Padding = UDim.new(0, 5)

-----------------------------------------------------------
-- PHẦN 1: LOGIC BAY (FlyPage)
-----------------------------------------------------------
local speeds = 1
local nowe = false
local moveUp, moveDown = false, false
local speaker = game.Players.LocalPlayer

local onof = Instance.new("TextButton", FlyPage)
onof.Size = UDim2.new(0.8, 0, 0, 30); onof.Position = UDim2.new(0.1, 0, 0, 0)
onof.Text = "BẬT BAY"; onof.BackgroundColor3 = Color3.fromRGB(30, 30, 30); onof.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", onof)

local up = Instance.new("TextButton", FlyPage)
up.Position = UDim2.new(0.1, 0, 0.35, 0); up.Size = UDim2.new(0, 35, 0, 35)
up.Text = "↑"; up.BackgroundColor3 = Color3.fromRGB(25, 25, 25); up.TextColor3 = Color3.fromRGB(255, 140, 0)
Instance.new("UICorner", up)

local down = Instance.new("TextButton", FlyPage)
down.Position = UDim2.new(0.35, 0, 0.35, 0); down.Size = UDim2.new(0, 35, 0, 35)
down.Text = "↓"; down.BackgroundColor3 = Color3.fromRGB(25, 25, 25); down.TextColor3 = Color3.fromRGB(255, 140, 0)
Instance.new("UICorner", down)

onof.MouseButton1Click:Connect(function()
    nowe = not nowe
    local char = speaker.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if nowe then
        onof.Text = "ĐANG BAY"; onof.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        hum.PlatformStand = true
        local bg = Instance.new("BodyGyro", root); bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        local bv = Instance.new("BodyVelocity", root); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while nowe do
                local cam = workspace.CurrentCamera
                if hum.MoveDirection.Magnitude > 0 then
                    bv.velocity = cam.CFrame.LookVector * (speeds * 50)
                else
                    local vF = 0
                    if moveUp then vF = speeds * 50 elseif moveDown then vF = -speeds * 50 end
                    bv.velocity = Vector3.new(0, vF, 0)
                end
                bg.cframe = cam.CFrame; task.wait()
            end
            bg:Destroy(); bv:Destroy(); hum.PlatformStand = false
        end)
    else
        onof.Text = "BẬT BAY"; onof.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-----------------------------------------------------------
-- PHẦN 2: CÔNG CỤ (ToolPage)
-----------------------------------------------------------
local lastPart = nil

local function createToolBtn(text, color)
    local btn = Instance.new("TextButton", ToolPage)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    return btn
end

local f3xBtn = createToolBtn("MỞ F3X", Color3.fromRGB(40, 40, 40))
local makeBtn = createToolBtn("TẠO KHỐI", Color3.fromRGB(0, 150, 0))
local ghostBtn = createToolBtn("XUYÊN THẤU", Color3.fromRGB(0, 100, 200))
local delBtn = createToolBtn("XÓA KHỐI", Color3.fromRGB(150, 0, 0))

f3xBtn.MouseButton1Click:Connect(function() loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)() end)

makeBtn.MouseButton1Click:Connect(function()
    local p = Instance.new("Part", workspace)
    p.Size = Vector3.new(6, 1, 6)
    p.Position = speaker.Character.HumanoidRootPart.Position + Vector3.new(0, -3.5, 0)
    p.Anchored = true
    p.BrickColor = BrickColor.new("Bright orange")
    lastPart = p
end)

ghostBtn.MouseButton1Click:Connect(function()
    if lastPart then lastPart.CanCollide = not lastPart.CanCollide lastPart.Transparency = 0.5 end
end)

delBtn.MouseButton1Click:Connect(function()
    if lastPart then lastPart:Destroy() lastPart = nil end
end)

-----------------------------------------------------------
-- HỆ THỐNG CHUYỂN TAB
-----------------------------------------------------------
FlyTabBtn.MouseButton1Click:Connect(function()
    FlyPage.Visible = true; ToolPage.Visible = false
    FlyTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); ToolTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

ToolTabBtn.MouseButton1Click:Connect(function()
    FlyPage.Visible = false; ToolPage.Visible = true
    FlyTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); ToolTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

close.Parent = Frame; close.Position = UDim2.new(0.85, 0, 0, 0); close.Size = UDim2.new(0, 25, 0, 25)
close.Text = "×"; close.TextColor3 = Color3.fromRGB(255, 0, 0); close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function() main:Destroy(); nowe = false end)
