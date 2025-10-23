-- SimpleGUI Library (with fix for slider value label position)

local SimpleGUI = {}
SimpleGUI.__index = SimpleGUI

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

function SimpleGUI.new(options)
    local self = setmetatable({}, SimpleGUI)
    
    local player = game.Players.LocalPlayer
    
    -- Default options
    options = options or {}
    self.title = options.title or "Simple GUI"
    self.size = options.size or UDim2.new(0, 400, 0, 250)
    self.position = options.position or UDim2.new(0, 20, 0, 20)
    
    -- Create ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "SimpleGUIScreen"
    self.screenGui.Parent = player.PlayerGui
    
    -- Main Frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = self.size
    self.mainFrame.Position = self.position
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    self.mainFrame.BackgroundTransparency = 0.1
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.mainFrame
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = self.mainFrame
    
    self.mainFrame.Parent = self.screenGui
    
    -- Header
    self.header = Instance.new("Frame")
    self.header.Size = UDim2.new(1, 0, 0, 50)
    self.header.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    self.header.BorderSizePixel = 0
    self.header.Parent = self.mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = self.header
    
    -- Logo Label
    self.logoLabel = Instance.new("TextLabel")
    self.logoLabel.Size = UDim2.new(1, -20, 1, 0)
    self.logoLabel.Position = UDim2.new(0, 15, 0, 0)
    self.logoLabel.BackgroundTransparency = 1
    self.logoLabel.Text = self.title
    self.logoLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    self.logoLabel.Font = Enum.Font.GothamBold
    self.logoLabel.TextSize = 20
    self.logoLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.logoLabel.TextTransparency = 0
    self.logoLabel.Parent = self.header
    
    -- Pulsing effect for logo
    spawn(function()
        while true do
            for i = 0, 1, 0.05 do
                self.logoLabel.TextTransparency = 0.1 + math.sin(i * math.pi) * 0.1
                wait(0.03)
            end
        end
    end)
    
    -- Content Frame
    self.contentFrame = Instance.new("Frame")
    self.contentFrame.Size = UDim2.new(1, 0, 1, -50)
    self.contentFrame.Position = UDim2.new(0, 0, 0, 50)
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.Parent = self.mainFrame
    
    -- Tabs Frame (left sidebar)
    self.tabsFrame = Instance.new("Frame")
    self.tabsFrame.Size = UDim2.new(0, 100, 1, 0)
    self.tabsFrame.Position = UDim2.new(0, 0, 0, 0)
    self.tabsFrame.BackgroundTransparency = 1
    self.tabsFrame.Parent = self.contentFrame
    
    self.tabsList = Instance.new("UIListLayout")
    self.tabsList.SortOrder = Enum.SortOrder.LayoutOrder
    self.tabsList.Padding = UDim.new(0, 5)
    self.tabsList.Parent = self.tabsFrame
    
    -- Sections Container (right content)
    self.sectionsContainer = Instance.new("Frame")
    self.sectionsContainer.Size = UDim2.new(1, -100, 1, 0)
    self.sectionsContainer.Position = UDim2.new(0, 100, 0, 0)
    self.sectionsContainer.BackgroundTransparency = 1
    self.sectionsContainer.Parent = self.contentFrame
    
    -- Table to hold tabs and sections
    self.tabs = {}
    self.sections = {}
    self.currentTab = nil
    
    -- Fade in
    self.mainFrame.BackgroundTransparency = 1
    self.logoLabel.TextTransparency = 1
    
    local fadeInTween = TweenService:Create(
        self.mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.1}
    )
    
    wait(0.5)
    fadeInTween:Play()
    
    TweenService:Create(
        self.logoLabel,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    ):Play()
    
    return self
end

-- Method to add a tab/section
function SimpleGUI:AddTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Text = name
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.LayoutOrder = #self.tabs + 1
    tabButton.AutoButtonColor = false
    
    local cor = Instance.new("UICorner")
    cor.CornerRadius = UDim.new(0, 6)
    cor.Parent = tabButton
    
    tabButton.Parent = self.tabsFrame
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, 0, 1, 0)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Visible = false
    sectionFrame.Parent = self.sectionsContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = sectionFrame
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.Parent = sectionFrame
    
    local innerLayout = Instance.new("UIListLayout")
    innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    innerLayout.Padding = UDim.new(0, 10)
    innerLayout.Parent = scrollingFrame
    
    table.insert(self.tabs, {button = tabButton, frame = sectionFrame, name = name})
    
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    if not self.currentTab then
        self:SelectTab(name)
    end
    
    return sectionFrame
end

-- Method to select a tab
function SimpleGUI:SelectTab(name)
    for _, tab in ipairs(self.tabs) do
        if tab.name == name then
            tab.button.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
            tab.frame.Visible = true
            self.currentTab = name
        else
            tab.button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            tab.frame.Visible = false
        end
    end
end

-- Method to add a button to a section
function SimpleGUI:AddButton(section, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 16
    button.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Hover effects
    local hoverTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 140, 220)})
    local normalTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 120, 200)})
    local activeTween = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 100, 180)})
    
    button.MouseEnter:Connect(function() hoverTween:Play() end)
    button.MouseLeave:Connect(function() normalTween:Play() end)
    button.MouseButton1Down:Connect(function() activeTween:Play() end)
    button.MouseButton1Up:Connect(function() hoverTween:Play() end)
    
    button.MouseButton1Click:Connect(callback)
    
    button.Parent = section:FindFirstChildOfClass("ScrollingFrame") or section
    
    -- Fade in
    button.BackgroundTransparency = 1
    button.TextTransparency = 1
    TweenService:Create(button, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    
    return button
end

-- Method to add a slider to a section
function SimpleGUI:AddSlider(section, name, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = section:FindFirstChildOfClass("ScrollingFrame") or section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = sliderFrame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -60, 0, 10)  -- Reduced width to make space for value label inside
    track.Position = UDim2.new(0, 0, 0, 25)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 5)
    trackCorner.Parent = track
    track.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 140, 220)
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = fill
    fill.Parent = track
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 0, 0, -5)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    knob.Text = ""
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0.5, 0)
    knobCorner.Parent = knob
    knob.Parent = track
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, 10, 0, -5)  -- Positioned to the right of the track
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 12
    valueLabel.Parent = sliderFrame  -- Parent to sliderFrame to avoid clipping issues
    
    local dragging = false
    
    local function updateValue(pos)
        local relative = math.clamp((pos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = minVal + (maxVal - minVal) * relative
        value = math.round(value)
        fill.Size = UDim2.new(relative, 0, 1, 0)
        knob.Position = UDim2.new(relative, -10, 0, -5)
        valueLabel.Text = tostring(value)
        callback(value)
    end
    
    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = game.Players.LocalPlayer:GetMouse().X
            updateValue(mousePos)
        end
    end)
    
    -- Set default
    local defaultRel = (defaultVal - minVal) / (maxVal - minVal)
    updateValue(track.AbsolutePosition.X + defaultRel * track.AbsoluteSize.X)
    
    -- Fade in
    TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(track, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    
    return sliderFrame
end

-- Method to add a label to a section
function SimpleGUI:AddLabel(section, text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or Color3.fromRGB(200, 200, 220)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextTransparency = 0
    label.Parent = section:FindFirstChildOfClass("ScrollingFrame") or section
    
    -- Fade in
    label.TextTransparency = 1
    TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    return label
end

return SimpleGUI
