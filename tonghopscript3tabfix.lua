local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local main = Instance.new("ScreenGui")
main.Name = "XNEO_HUB_V5_4"
main.Parent = game.CoreGui
main.ResetOnSpawn = false

local Frame = Instance.new("Frame", main)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.Size = UDim2.new(0, 200, 0, 220)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.Active = true
Frame.Draggable = true 

Instance.new("UICorner", Frame)
local stroke = Instance.new("UIStroke", Frame)
stroke.Color = Color3.fromRGB(255, 140, 0)
stroke.Thickness = 2

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "XNEO HUB V5.4"
Title.TextColor3 = Color3.fromRGB(255, 140, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- Menu Tab
local TabContainer = Instance.new("Frame", Frame)
TabContainer.Position = UDim2.new(0, 0, 0.15, 0)
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.BackgroundTransparency = 1

local FlyPage = Instance.new("Frame", Frame)
local ToolPage = Instance.new("ScrollingFrame", Frame)
local ScriptPage = Instance.new("ScrollingFrame", Frame)

local function setupPage(page)
    page.Position = UDim2.new(0, 0, 0.32, 0)
    page.Size = UDim2.new(1, 0, 0.65, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    if page:IsA("ScrollingFrame") then
        page.CanvasSize = UDim2.new(0, 0, 2.5, 0)
        page.ScrollBarThickness = 0
        local l = Instance.new("UIListLayout", page)
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
        l.Padding = UDim.new(0, 5)
    end
end
setupPage(FlyPage); setupPage(ToolPage); setupPage(ScriptPage)
FlyPage.Visible = true

local function makeTab(txt, pos, pg)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.3, 0, 0.8, 0)
    btn.Position = pos
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        FlyPage.Visible = false; ToolPage.Visible = false; ScriptPage.Visible = false
        pg.Visible = true
    end)
end
makeTab("BAY", UDim2.new(0.03, 0, 0, 0), FlyPage)
makeTab("CÔNG CỤ", UDim2.new(0.35, 0, 0, 0), ToolPage)
makeTab("SCRIPT", UDim2.new(0.67, 0, 0, 0), ScriptPage)

-----------------------------------------------------------
-- PHẦN 1: TAB BAY (FIX LỖI JOYSICK)
-----------------------------------------------------------
local speeds = 1
local nowe = false
local moveUp, moveDown = false, false

local flyBtn = Instance.new("TextButton", FlyPage)
flyBtn.Size = UDim2.new(0.8, 0, 0, 35); flyBtn.Position = UDim2.new(0.1, 0, 0, 0)
flyBtn.Text = "BẬT BAY"; flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", flyBtn)

flyBtn.MouseButton1Click:Connect(function()
    nowe = not nowe
    flyBtn.Text = nowe and "ĐANG BAY" or "BẬT BAY"
    flyBtn.BackgroundColor3 = nowe and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(40, 40, 40)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if nowe and root and hum then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0, 0, 0)
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 9e4
        task.spawn(function()
            while nowe do
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local finalVel = (camera.CFrame * CFrame.new(moveDir.X * (speeds * 50), 0, moveDir.Z * (speeds * 50))).Position - camera.CFrame.Position
                    bv.Velocity = finalVel.Unit * (speeds * 50)
                else
                    local vf = 0
                    if moveUp then vf = speeds * 50 elseif moveDown then vf = -speeds * 50 end
                    bv.Velocity = Vector3.new(0, vf, 0)
                end
                bg.CFrame = camera.CFrame
                runService.Heartbeat:Wait()
            end
            bv:Destroy(); bg:Destroy(); hum.PlatformStand = false
        end)
    end
end)

local function addMoveBtn(txt, pos, var)
    local b = Instance.new("TextButton", FlyPage)
    b.Text = txt; b.Size = UDim2.new(0, 40, 0, 40); b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.fromRGB(255, 140, 0)
    Instance.new("UICorner", b)
    b.InputBegan:Connect(function() if var == "up" then moveUp = true else moveDown = true end end)
    b.InputEnded:Connect(function() if var == "up" then moveUp = false else moveDown = false end end)
end
addMoveBtn("↑", UDim2.new(0.2, 0, 0.4, 0), "up")
addMoveBtn("↓", UDim2.new(0.5, 0, 0.4, 0), "down")

-----------------------------------------------------------
-- PHẦN 2: TAB CÔNG CỤ (FIXED XÓA/XUYÊN KHỐI)
-----------------------------------------------------------
local createdParts = {}
local ghosting = false

local function createTool(txt, func)
    local b = Instance.new("TextButton", ToolPage)
    b.Size = UDim2.new(0.9, 0, 0, 30); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(func)
end

createTool("MỞ F3X", function() loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)() end)

createTool("TẠO KHỐI", function() 
    local p = Instance.new("Part", workspace); p.Size = Vector3.new(6, 1, 6)
    p.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -3.5, 0)
    p.Anchored = true; p.BrickColor = BrickColor.new("Bright orange")
    table.insert(createdParts, p)
end)

createTool("XUYÊN/CỨNG KHỐI", function() 
    ghosting = not ghosting
    for _, p in pairs(createdParts) do
        if p and p.Parent then
            p.CanCollide = not ghosting
            p.Transparency = ghosting and 0.5 or 0
        end
    end
end)

createTool("XÓA TẤT CẢ KHỐI", function() 
    for _, p in pairs(createdParts) do if p then p:Destroy() end end
    createdParts = {}
end)

-----------------------------------------------------------
-- PHẦN 3: TAB SCRIPT (SPEED, ESP, NOCLIP, INF JUMP)
-----------------------------------------------------------
local infJumpActive = false
local holdingJump = false
userInput.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.KeyCode == Enum.KeyCode.Space then holdingJump = true end end)
userInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.KeyCode == Enum.KeyCode.Space then holdingJump = false end end)
runService.RenderStepped:Connect(function() if infJumpActive and holdingJump then local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

local function addToggle(txt, pg, func)
    local b = Instance.new("TextButton", pg); b.Size = UDim2.new(0.9, 0, 0, 30); b.Text = txt .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b); local state = false
    b.MouseButton1Click:Connect(function()
        state = not state; b.Text = txt .. (state and ": ON" or ": OFF")
        b.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35); func(state)
    end)
end

addToggle("INF JUMP (ĐÈ NÚT)", ScriptPage, function(s) infJumpActive = s end)
addToggle("SPEED 50", ScriptPage, function(s) player.Character.Humanoid.WalkSpeed = s and 50 or 16 end)
addToggle("ESP PLAYER", ScriptPage, function(s)
    if s then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local b = Instance.new("BillboardGui", p.Character.Head); b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true; b.Name = "XESP"
                local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255,0,0); l.TextSize = 10
                task.spawn(function() while b.Parent do local d = math.floor((player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) l.Text = p.Name .. "\n[" .. d .. "m]"; task.wait(0.5) end end)
            end
        end
    else
        for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character.Head:FindFirstChild("XESP") then p.Character.Head.XESP:Destroy() end end
    end
end)
addToggle("FLOAT", ScriptPage, function(s)
    local r = player.Character.HumanoidRootPart
    if s then local bv = Instance.new("BodyVelocity", r); bv.Name = "XF"; bv.MaxForce = Vector3.new(0, 9e9, 0); bv.Velocity = Vector3.new(0, 0, 0) else if r:FindFirstChild("XF") then r.XF:Destroy() end end
end)
addToggle("NOCLIP", ScriptPage, function(s)
    _G.nocl = s
    runService.Stepped:Connect(function() if _G.nocl and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
end)

local close = Instance.new("TextButton", Frame)
close.Size = UDim2.new(0, 25, 0, 25); close.Position = UDim2.new(0.85, 0, 0, 0); close.Text = "×"; close.TextColor3 = Color3.fromRGB(255, 0, 0); close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function() main:Destroy() nowe = false end)
