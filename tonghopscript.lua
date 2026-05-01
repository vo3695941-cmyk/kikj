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
local ScriptTabBtn = Instance.new("TextButton")

-- Các trang nội dung
local FlyPage = Instance.new("Frame")
local ToolPage = Instance.new("ScrollingFrame")
local ScriptPage = Instance.new("ScrollingFrame")

main.Name = "XNEO_HUB_V4"
main.Parent = game.CoreGui
main.ResetOnSpawn = false

-- Khung chính
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 200, 0, 220)
Frame.Active = true
Frame.Draggable = true 

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", Frame)
stroke.Color = Color3.fromRGB(255, 140, 0)
stroke.Thickness = 2

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "XNEO HUB V4"
Title.TextColor3 = Color3.fromRGB(255, 140, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- Thanh Tab
TabContainer.Parent = Frame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 0, 0.15, 0)
TabContainer.Size = UDim2.new(1, 0, 0, 25)

local function createTabBtn(text, pos)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.33, 0, 1, 0)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    Instance.new("UICorner", btn)
    return btn
end

FlyTabBtn = createTabBtn("Bay", UDim2.new(0, 0, 0, 0))
ToolTabBtn = createTabBtn("C.Cụ", UDim2.new(0.33, 0, 0, 0))
ScriptTabBtn = createTabBtn("Script", UDim2.new(0.66, 0, 0, 0))

-- Cài đặt trang nội dung
local function setupPage(page)
    page.Parent = Frame
    page.BackgroundTransparency = 1
    page.Position = UDim2.new(0, 0, 0.3, 0)
    page.Size = UDim2.new(1, 0, 0.7, 0)
    page.Visible = false
    if page:IsA("ScrollingFrame") then
        page.CanvasSize = UDim2.new(0, 0, 1.5, 0)
        page.ScrollBarThickness = 0
        local layout = Instance.new("UIListLayout", page)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Padding = UDim.new(0, 5)
    end
end

setupPage(FlyPage)
setupPage(ToolPage)
setupPage(ScriptPage)
FlyPage.Visible = true

-----------------------------------------------------------
-- TAB 1: BAY (FLY)
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

local speedDisp = Instance.new("TextLabel", FlyPage)
speedDisp.Position = UDim2.new(0.7, 0, 0.35, 0); speedDisp.Size = UDim2.new(0, 30, 0, 35)
speedDisp.Text = "1"; speedDisp.TextColor3 = Color3.fromRGB(255, 255, 255); speedDisp.BackgroundTransparency = 1

up.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveUp = true end end)
up.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveUp = false end end)
down.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveDown = true end end)
down.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveDown = false end end)

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
-- TAB 2: CÔNG CỤ (ToolPage - F3X & Build)
-----------------------------------------------------------
local lastPart = nil

local function createToolBtn(text, color)
    local btn = Instance.new("TextButton", ToolPage)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = color; btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn); return btn
end

local f3xBtn = createToolBtn("MỞ F3X", Color3.fromRGB(40, 40, 40))
local makeBtn = createToolBtn("TẠO KHỐI", Color3.fromRGB(0, 150, 0))
local ghostBtn = createToolBtn("XUYÊN THẤU", Color3.fromRGB(0, 100, 200))
local delBtn = createToolBtn("XÓA KHỐI", Color3.fromRGB(150, 0, 0))

f3xBtn.MouseButton1Click:Connect(function() loadstring(game:GetObjects("rbxassetid://6695644299").Source)() end)
makeBtn.MouseButton1Click:Connect(function()
    local p = Instance.new("Part", workspace); p.Size = Vector3.new(6, 1, 6)
    p.Position = speaker.Character.HumanoidRootPart.Position + Vector3.new(0, -3.5, 0)
    p.Anchored = true; p.BrickColor = BrickColor.new("Bright orange"); lastPart = p
end)
ghostBtn.MouseButton1Click:Connect(function() if lastPart then lastPart.CanCollide = not lastPart.CanCollide; lastPart.Transparency = 0.5 end end)
delBtn.MouseButton1Click:Connect(function() if lastPart then lastPart:Destroy(); lastPart = nil end end)

-----------------------------------------------------------
-- TAB 3: SCRIPT (ScriptPage - Speed, Jump, ESP, Float)
-----------------------------------------------------------
local function addScriptBtn(text, func)
    local btn = Instance.new("TextButton", ScriptPage)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = text; btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn); btn.MouseButton1Click:Connect(func)
end

addScriptBtn("SPEED (Tăng tốc)", function()
    local h = speaker.Character.Humanoid
    h.WalkSpeed = h.WalkSpeed == 16 and 60 or 16
end)

local infJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then speaker.Character.Humanoid:ChangeState("Jumping") end
end)
addScriptBtn("INF JUMP (Nhảy vô hạn)", function() infJump = not infJump end)

addScriptBtn("ESP PLAYER (Hiện tên)", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= speaker and p.Character and p.Character:FindFirstChild("Head") then
            local b = Instance.new("BillboardGui", p.Character.Head)
            b.Size = UDim2.new(0, 100, 0, 50); b.AlwaysOnTop = true
            local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.spawn(function()
                while p.Character do
                    local d = math.floor((speaker.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                    l.Text = p.Name .. "\n[" .. d .. "m]"; task.wait(0.5)
                end
            end)
        end
    end
end)

local floating = false
addScriptBtn("FLOAT (Lơ lửng)", function()
    floating = not floating
    local r = speaker.Character.HumanoidRootPart
    if floating then
        local bv = Instance.new("BodyVelocity", r); bv.Name = "Float"; bv.MaxForce = Vector3.new(0, 9e9, 0); bv.Velocity = Vector3.new(0, 0, 0)
    else
        if r:FindFirstChild("Float") then r.Float:Destroy() end
    end
end)

-----------------------------------------------------------
-- HỆ THỐNG CHUYỂN TAB & ĐÓNG
-----------------------------------------------------------
local function switch(tab)
    FlyPage.Visible = (tab == "Fly"); ToolPage.Visible = (tab == "Tool"); ScriptPage.Visible = (tab == "Script")
end
FlyTabBtn.MouseButton1Click:Connect(function() switch("Fly") end)
ToolTabBtn.MouseButton1Click:Connect(function() switch("Tool") end)
ScriptTabBtn.MouseButton1Click:Connect(function() switch("Script") end)

close.Parent = Frame; close.Position = UDim2.new(0.85, 0, 0, 0); close.Size = UDim2.new(0, 25, 0, 25)
close.Text = "×"; close.TextColor3 = Color3.fromRGB(255, 0, 0); close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function() main:Destroy(); nowe = false end)

game:GetService("StarterGui"):SetCore("SendNotification", { Title = "XNEO HUB V4", Text = "Đã tổng hợp thành công!", Duration = 5})
