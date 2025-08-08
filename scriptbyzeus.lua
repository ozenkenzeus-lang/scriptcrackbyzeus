--==========================
-- Auto Attack Boss GUI
-- Pass mở khóa: WK|Wukong
--==========================

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Cài đặt mặc định
local radius = 20        -- Khoảng cách đứng đánh
local speed = 2          -- Tốc độ đánh
local running = false    -- Trạng thái auto chạy
local autoAttack = false -- Tự động đánh
local guiVisible = false -- Hiển thị GUI

--==========================
-- GUI CHÍNH
--==========================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Menu_TT"
gui.Enabled = false

-- Frame chính
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 270)
frame.Position = UDim2.new(0.5, -150, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

-- Toggle auto
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, 0, 0, 40)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.Text = "Bật: Đánh Boss"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Input khoảng cách
local distLabel = Instance.new("TextLabel", frame)
distLabel.Text = "Khoảng cách:"
distLabel.Size = UDim2.new(0, 150, 0, 30)
distLabel.Position = UDim2.new(0, 10, 0, 50)
distLabel.TextColor3 = Color3.new(1, 1, 1)
distLabel.BackgroundTransparency = 1

local distInput = Instance.new("TextBox", frame)
distInput.Size = UDim2.new(0, 100, 0, 30)
distInput.Position = UDim2.new(0, 160, 0, 50)
distInput.Text = tostring(radius)
distInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
distInput.TextColor3 = Color3.new(1, 1, 1)

-- Input tốc độ đánh
local spdLabel = Instance.new("TextLabel", frame)
spdLabel.Text = "Tốc độ đánh:"
spdLabel.Size = UDim2.new(0, 150, 0, 30)
spdLabel.Position = UDim2.new(0, 10, 0, 90)
spdLabel.TextColor3 = Color3.new(1, 1, 1)
spdLabel.BackgroundTransparency = 1

local spdInput = Instance.new("TextBox", frame)
spdInput.Size = UDim2.new(0, 100, 0, 30)
spdInput.Position = UDim2.new(0, 160, 0, 90)
spdInput.Text = tostring(speed)
spdInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spdInput.TextColor3 = Color3.new(1, 1, 1)

-- Hiển thị máu boss
local hpLabel = Instance.new("TextLabel", frame)
hpLabel.Size = UDim2.new(1, -20, 0, 30)
hpLabel.Position = UDim2.new(0, 10, 0, 130)
hpLabel.Text = "Máu Boss NCP2: ..."
hpLabel.TextColor3 = Color3.new(1, 0, 0)
hpLabel.BackgroundTransparency = 1
hpLabel.TextScaled = true

-- Auto Attack Button
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1, 0, 0, 30)
autoBtn.Position = UDim2.new(0, 0, 0, 170)
autoBtn.Text = "Bật: Auto Đánh"
autoBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoBtn.TextColor3 = Color3.new(1, 1, 1)

-- Ô nhập pass
local passGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
passGui.Name = "PassCheck"

local passFrame = Instance.new("Frame", passGui)
passFrame.Size = UDim2.new(0, 250, 0, 130)
passFrame.Position = UDim2.new(0.5, -125, 0.5, -65)
passFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local title = Instance.new("TextLabel", passFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.Text = "Nhập Mật Khẩu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextScaled = true

local passInput = Instance.new("TextBox", passFrame)
passInput.Size = UDim2.new(0.9, 0, 0, 30)
passInput.Position = UDim2.new(0.05, 0, 0, 45)
passInput.PlaceholderText = "••••••••"
passInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
passInput.TextColor3 = Color3.new(1, 1, 1)

local checkBtn = Instance.new("TextButton", passFrame)
checkBtn.Size = UDim2.new(0.5, 0, 0, 30)
checkBtn.Position = UDim2.new(0.25, 0, 0, 85)
checkBtn.Text = "Xác nhận"
checkBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
checkBtn.TextColor3 = Color3.new(1, 1, 1)

--==========================
-- CHỨC NĂNG
--==========================

-- Tìm boss gần nhất
local function getTarget()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model")
           and v:FindFirstChild("Humanoid")
           and v ~= Character
           and v:FindFirstChild("HumanoidRootPart")
           and v.Humanoid.Health > 0 then
            return v
        end
    end
end

-- Đánh
local function attack()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

--==========================
-- SỰ KIỆN
--==========================

-- Xác nhận pass
checkBtn.MouseButton1Click:Connect(function()
    if passInput.Text == "WK|Wukong" then
        gui.Enabled = true
        passGui:Destroy()
    end
end)

-- Toggle auto run
toggleBtn.MouseButton1Click:Connect(function()
    running = not running
    toggleBtn.Text = running and "Tắt: Đánh Boss" or "Bật: Đánh Boss"
end)

-- Thay đổi khoảng cách
distInput.FocusLost:Connect(function()
    radius = tonumber(distInput.Text) or radius
end)

-- Thay đổi tốc độ
spdInput.FocusLost:Connect(function()
    speed = tonumber(spdInput.Text) or speed
end)

-- Toggle auto attack
autoBtn.MouseButton1Click:Connect(function()
    autoAttack = not autoAttack
    autoBtn.Text = autoAttack and "Tắt: Auto Đánh" or "Bật: Auto Đánh"
end)

-- Loop auto
RunService.Heartbeat:Connect(function()
    if running then
        local target = getTarget()
        if target then
            local angle = tick() * speed
            local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            local goalPos = target.HumanoidRootPart.Position + offset

            TweenService:Create(HumanoidRootPart, TweenInfo.new(0.1), {CFrame = CFrame.new(goalPos, target.HumanoidRootPart.Position)}):Play()
            Humanoid.AutoRotate = false

            if autoAttack then attack() end
            hpLabel.Text = "Máu mục tiêu: " .. math.floor(target.Humanoid.Health)
        end
    end
end)
