local SimpleGUI = {}

function SimpleGUI:CreateWindow(title, sizeX, sizeY)
    sizeX = sizeX or 300
    sizeY = sizeY or 400

    local gui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, sizeX, 0, sizeY)
    frame.Position = UDim2.new(0.5, -sizeX/2, 0.5, -sizeY/2)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.Active = true
    frame.Draggable = true

    -- Заголовок
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundColor3 = Color3.fromRGB(50,50,50)
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = title or "Window"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20

    frame.Buttons = {}

    function frame:AddButton(btnText, callback)
        local btn = Instance.new("TextButton", self)
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, 40 + (#self.Buttons * 50))
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Text = btnText
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.AutoButtonColor = true
        btn.Visible = true

        -- Скругление углов
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)

        -- Безопасный callback
        btn.MouseButton1Click:Connect(function()
            if callback then
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                callback(humanoid)
            end
        end)

        table.insert(self.Buttons, btn)
    end

    return frame
end

return SimpleGUI
