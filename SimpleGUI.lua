local SimpleGUI = {}

local function make_shadow(parent, depth)
    local shadow = Instance.new("ImageLabel")
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://4483369609"  -- Roblox стандартная тень
    shadow.ImageTransparency = 0.65
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.Size = UDim2.new(1, depth*2, 1, depth*2)
    shadow.Position = UDim2.new(0, -depth, 0, -depth)
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
end

function SimpleGUI:CreateWindow(title, sizeX, sizeY)
    -- screen gui
    local gui = Instance.new("ScreenGui")
    gui.Name = "CustomSimpleGUI"
    gui.Parent = game.CoreGui

    -- Main window (frame)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, sizeX or 340, 0, sizeY or 440)
    frame.Position = UDim2.new(0.5, -((sizeX or 340) / 2), 0.47, -((sizeY or 440) / 2))
    frame.AnchorPoint = Vector2.new(0,0)
    frame.BackgroundColor3 = Color3.fromRGB(26, 27, 32)
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    frame.Parent = gui

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 16)

    make_shadow(frame, 12)

    -- Header (title bar)
    local header = Instance.new("Frame")
    header.Parent = frame
    header.Size = UDim2.new(1, 0, 0, 48)
    header.BackgroundColor3 = Color3.fromRGB(38, 41, 54)
    header.BorderSizePixel = 0
    header.ZIndex = 3

    local header_corner = Instance.new("UICorner", header)
    header_corner.CornerRadius = UDim.new(0, 16)

    local lbl = Instance.new("TextLabel", header)
    lbl.Text = title or "Window"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(227, 229, 240)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 21
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.ZIndex = 4

    -- Drag logic за хедер
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Кнопочная зона (scrollable)
    local buttonArea = Instance.new("ScrollingFrame", frame)
    buttonArea.Name = "ButtonArea"
    buttonArea.Position = UDim2.new(0, 0, 0, 54)
    buttonArea.Size = UDim2.new(1, 0, 1, -54)
    buttonArea.BackgroundTransparency = 1
    buttonArea.ZIndex = 3
    buttonArea.ScrollBarThickness = 4
    buttonArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    buttonArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    buttonArea.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    
    local layout = Instance.new("UIListLayout", buttonArea)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    
    -- Update canvas size when layout changes
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        buttonArea.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    frame.Buttons = {}

    function frame:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = buttonArea
        btn.Size = UDim2.new(0.92, 0, 0, 44)
        btn.BackgroundColor3 = Color3.fromRGB(44, 52, 70)
        btn.AutoButtonColor = false
        btn.Text = text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextColor3 = Color3.fromRGB(230,235,243)
        btn.TextSize = 19
        btn.ZIndex = 4
        btn.LayoutOrder = #frame.Buttons + 1

        local uic = Instance.new("UICorner", btn)
        uic.CornerRadius = UDim.new(0, 12)
        local uistroke = Instance.new("UIStroke", btn)
        uistroke.Color = Color3.fromRGB(37,42,65)
        uistroke.Thickness = 1.1
        uistroke.Transparency = 0.48

        local shadow = make_shadow(btn, 4)
        shadow.ZIndex = btn.ZIndex - 1

        -- Hover эффект
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(54, 58, 92)
            btn.TextColor3 = Color3.fromRGB(245, 245, 255)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(44, 52, 70)
            btn.TextColor3 = Color3.fromRGB(230,235,243)
        end)

        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        table.insert(frame.Buttons, btn)
    end

    return frame
end

return SimpleGUI
