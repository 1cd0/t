-- User Interface Library

local UI = {}

-- Create a ScreenGui
function UI.createScreenGui(parent)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = parent or game.Players.LocalPlayer.PlayerGui
    return screenGui
end

-- Create a window
function UI.createWindow(parent, title, position, size)
    -- Main window frame
    local window = Instance.new("Frame")
    window.Size = size or UDim2.new(0, 400, 0, 300)
    window.Position = position or UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    window.BorderSizePixel = 0
    window.Parent = parent

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window

    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Text = title or "Window"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = titleBar

    -- Draggable functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil

    titleBar.MouseButton1Down:Connect(function(input)
        dragging = true
        dragStart = input.Position
        startPos = window.Position
    end)

    titleBar.MouseButton1Up:Connect(function()
        dragging = false
    end)

    titleBar.MouseMoved:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return window
end

-- Create a button
function UI.createButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 100, 0, 40)
    button.Position = position or UDim2.new(0, 50, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text or "Button"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = parent

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

-- Create a slider
function UI.createSlider(parent, minValue, maxValue, startValue, position, size, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = size or UDim2.new(0, 300, 0, 50)
    sliderFrame.Position = position or UDim2.new(0, 50, 0, 100)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent

    -- Slider Bar
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 10)
    sliderBar.Position = UDim2.new(0, 0, 0.5, -5)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    sliderBar.Parent = sliderFrame

    -- Slider Button
    local sliderButton = Instance.new("ImageButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new(0, (startValue - minValue) / (maxValue - minValue) * sliderBar.Size.X.Offset, 0, -5)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BackgroundTransparency = 0.5
    sliderButton.Image = "rbxassetid://317113230"
    sliderButton.Parent = sliderFrame

    -- Slider dragging functionality
    local draggingSlider = false
    local sliderStartPos = nil

    sliderButton.MouseButton1Down:Connect(function(input)
        draggingSlider = true
        sliderStartPos = input.Position.X
    end)

    sliderButton.MouseButton1Up:Connect(function()
        draggingSlider = false
    end)

    sliderButton.MouseMoved:Connect(function(input)
        if draggingSlider then
            local delta = input.Position.X - sliderStartPos
            local newPos = math.clamp(sliderButton.Position.X.Offset + delta, 0, sliderBar.Size.X.Offset - sliderButton.Size.X.Offset)
            sliderButton.Position = UDim2.new(0, newPos, 0, -5)

            local value = math.floor((newPos / (sliderBar.Size.X.Offset - sliderButton.Size.X.Offset)) * (maxValue - minValue) + minValue)
            if callback then
                callback(value)
            end

            sliderStartPos = input.Position.X
        end
    end)

    return sliderFrame
end

-- Create a textbox
function UI.createTextBox(parent, placeholder, position, size, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = size or UDim2.new(0, 200, 0, 30)
    textBox.Position = position or UDim2.new(0, 50, 0, 160)
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.TextSize = 14
    textBox.BorderSizePixel = 0
    textBox.Parent = parent

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            if callback then
                callback(textBox.Text)
            end
        end
    end)

    return textBox
end

return UI
